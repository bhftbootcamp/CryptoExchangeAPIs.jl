module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30

Base.@kwdef struct CandleQuery <: GateioPublicQuery
    currency_pair::String
    from::Maybe{DateTime} = nothing
    interval::Maybe{TimeInterval} = nothing
    limit::Maybe{Int64} = nothing
    to::Maybe{DateTime} = nothing
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
    timestamp::Maybe{NanoDate}
    quote_volume::Maybe{Float64}
    close_price::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    open_price::Maybe{Float64}
    base_amount::Maybe{Float64}
end

"""
    candle(client::GateioClient, query::CandleQuery)
    candle(client::GateioClient = Gateio.Spot.public_client; kw...)

Market candlesticks.

[`GET api/v4/spot/candlesticks`](https://www.gate.io/docs/developers/apiv4/#market-candlesticks)

## Parameters:

| Parameter     | Type         | Required | Description                          |
|:--------------|:-------------|:---------|:-------------------------------------|
| currency_pair | String       | true     |                                      |
| from          | DateTime     | false    |                                      |
| interval      | TimeInterval | false    | s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30 |
| limit         | Int64        | false    |                                      |
| _end          | DateTime     | false    |                                      |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.Spot.candle(;
    currency_pair = "BTC_USDT",
    interval = Gateio.Spot.Candle.d1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "timestamp":"2023-12-17T00:00:00",
    "quote_volume":2.43940917037979e8,
    "close_price":41378.4,
    "high_price":42421.6,
    "low_price":41240.1,
    "open_price":42275.6,
    "base_amount":5819.36674398
  },
  ...
]
```
"""
function candle(client::GateioClient, query::CandleQuery)
    return APIsRequest{Vector{CandleData}}("GET", "api/v4/spot/candlesticks", query)(client)
end

function candle(client::GateioClient = Gateio.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
