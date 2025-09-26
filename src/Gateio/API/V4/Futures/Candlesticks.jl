module Candlesticks

export CandlesticksQuery,
    CandlesticksData,
    candlesticks

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30

@enumx ContractType mark index

@enumx Settle btc usdt usd

struct Contract
    type::ContractType.T
    name::String
end

struct CandlesticksQuery <: GateioPublicQuery
    contract::Contract
    settle::Settle.T
    from::Maybe{DateTime}
    to::Maybe{DateTime}
    limit::Maybe{Int64} 
    interval::Maybe{TimeInterval.T}
end

Serde.SerQuery.ser_ignore_field(::Type{CandlesticksQuery}, ::Val{:settle}) = true

function CandlesticksQuery(;
    type::ContractType.T,
    name::String,
    settle::Settle.T,
    from::Maybe{DateTime} = nothing,
    to::Maybe{DateTime} = nothing,
    limit::Maybe{Int64} = nothing,
    interval::Maybe{TimeInterval.T} = nothing,
)
    return CandlesticksQuery(Contract(type, name), settle, from, to, limit, interval)
end

function Serde.ser_type(::Type{<:CandlesticksQuery}, x::Contract)::String
    return string(x.type, "_", x.name)
end

function Serde.ser_type(::Type{<:CandlesticksQuery}, x::TimeInterval.T)::String
    x == TimeInterval.s10 && return "10s"
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d7  && return "7d"
    x == TimeInterval.d30 && return "30d"
end

struct CandlesticksData <: GateioData
    t::NanoDate
    v::Maybe{Int64}
    c::Maybe{Float64}
    h::Maybe{Float64}
    l::Maybe{Float64}
    o::Maybe{Float64}
    sum::Maybe{Float64}
end

"""
    candlesticks(client::GateioClient, query::CandlesticksQuery)
    candlesticks(client::GateioClient = Gateio.public_client; kw...)

Get futures candlesticks.

[`GET api/v4/futures/{settle}/candlesticks`](https://www.gate.io/docs/developers/apiv4/en/#get-futures-candlesticks)

## Parameters:

| Parameter | Type         | Required | Description                          |
|:----------|:-------------|:---------|:-------------------------------------|
| contract  | String       | true     |                                      |
| settle    | Settle       | true     | btc usdt usd                         |
| interval  | TimeInterval | false    | s10 m1 m5 m15 m30 h1 h4 h8 d1 d7 d30 |
| from      | DateTime     | false    |                                      |
| to        | DateTime     | false    |                                      |
| limit     | Int64        | false    |                                      |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.candlesticks(; 
    type = Gateio.API.V4.Futures.Candlesticks.ContractType.mark,
    name = "BTC_USDT",
    settle = Gateio.API.V4.Futures.Candlesticks.Settle.usdt,
    interval = Gateio.API.V4.Futures.Candlesticks.TimeInterval.d30,
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
function candlesticks(client::GateioClient, query::CandlesticksQuery)
    return APIsRequest{Vector{CandlesticksData}}("GET", "api/v4/futures/$(query.settle)/candlesticks", query)(client)
end

function candlesticks(client::GateioClient = Gateio.public_client; kw...)
    return candlesticks(client, CandlesticksQuery(; kw...))
end

end
