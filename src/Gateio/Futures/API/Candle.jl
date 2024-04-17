module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30

Base.@kwdef struct CandleQuery <: GateioPublicQuery
    contract::String
    from::Maybe{DateTime} = nothing
    to::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    interval::Maybe{TimeInterval} = nothing
end

function CandleQuery(contract::String)
    if occursin("mark_", contract)
        return CandleQuery(contract)
    else
        return CandleQuery("mark_" * contract)
    end
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == s10 && return "10s"
    x == m1  && return "1m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h4  && return "4h"
    x == h8  && return "8h"
    x == d1  && return "1d"
    x == d7  && return "7d"
    x == d30 && return "30d"
end

struct CandleData <: GateioData
    t::NanoDate
    v::Maybe{Int64}
    c::Maybe{Float64}
    h::Maybe{Float64}
    l::Maybe{Float64}
    o::Maybe{Float64}
    sum::Maybe{Float64}
end

"""
    candle(client::GateioClient, query::CandleQuery)
    candle(client::GateioClient = Gateio.Futures.public_client; kw...)

Get futures candlesticks.

[`GET api/v4/futures/{settle}/candlesticks`](https://www.gate.io/docs/developers/apiv4/en/#get-futures-candlesticks)

## Parameters:

| Parameter | Type         | Required | Description                          |
|:----------|:-------------|:---------|:-------------------------------------|
| contract  | String       | true     |                                      |
| interval  | TimeInterval | false    | s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30 |
| from      | DateTime     | false    |                                      |
| to        | DateTime     | false    |                                      |
| limit     | Int64        | false    |                                      |

## Code samples:

```julia
using Serde
using CryptoAPIs.Gateio

result = Gateio.Futures.candle(; 
    settle = "usdt",
    contract = "BTC_USDT", # "mark_" prefix will be prepended by default
    interval = Gateio.Futures.Candle.d30,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "t":"2024-03-01T00:00:00",
    "v":5932942626,
    "c":71360.4,
    "h":73879.3,
    "l":59059.0,
    "o":62415.7,
    "sum":4.003183751397624e10
  },
  ...
]
```
"""
function candle(client::GateioClient, query::CandleQuery; settle::String)
    return APIsRequest{Vector{CandleData}}("GET", "api/v4/futures/$settle/candlesticks", query)(client)
end

function candle(client::GateioClient = Gateio.Futures.public_client; settle::String, kw...)
    return candle(client, CandleQuery(; kw...); settle = settle)
end

end
