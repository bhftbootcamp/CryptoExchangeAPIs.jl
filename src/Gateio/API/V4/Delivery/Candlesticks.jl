module Candlesticks

export CandlesticksQuery,
    CandlesticksData,
    Settle,
    TimeInterval,
    candlesticks

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval s10 s30 m1 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d7 w1 d30

@enumx ContractType mark index

@enumx Settle usdt

struct Contract
    type::Maybe{ContractType.T}
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
    type::Maybe{ContractType.T} = nothing,
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
    return isnothing(x.type) ? x.name : string(x.type, "_", x.name)
end

function Serde.ser_type(::Type{<:CandlesticksQuery}, x::TimeInterval.T)::String
    x == TimeInterval.s10 && return "10s"
    x == TimeInterval.s30 && return "30s"
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d7  && return "7d"
    x == TimeInterval.w1  && return "1w"
    x == TimeInterval.d30 && return "30d"
end

struct CandlesticksData <: GateioData
    t::NanoDate
    v::Maybe{Int64}
    c::Maybe{Float64}
    h::Maybe{Float64}
    l::Maybe{Float64}
    o::Maybe{Float64}
end

"""
    candlesticks(client::GateioClient, query::CandlesticksQuery)
    candlesticks(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Get delivery futures candlesticks. If `type` is `mark` or `index`, contract name is
prefixed accordingly and volume is not returned. Maximum of 2000 points per query.
`limit` conflicts with `from`/`to`; if either is specified, `limit` is rejected.

[`GET api/v4/delivery/{settle}/candlesticks`](https://www.gate.com/docs/developers/apiv4/en/#futures-market-k-line-chart-2)

## Parameters:

| Parameter | Type         | Required | Description                                                                   |
|:----------|:-------------|:---------|:------------------------------------------------------------------------------|
| type      | ContractType | true     | mark index (prefix applied to contract name)                                  |
| name      | String       | true     | Contract name (e.g. BTC\\_USDT\\_20200814).                                   |
| settle    | Settle       | true     | usdt                                                                          |
| interval  | TimeInterval | false    | s10 s30 m1 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d7 w1 d30. Default: 5m.           |
| from      | DateTime     | false    | Start time (Unix seconds). Conflicts with limit.                              |
| to        | DateTime     | false    | End time (Unix seconds). Conflicts with limit.                                |
| limit     | Int64        | false    | Max recent points. Default 100. Conflicts with from/to.                       |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Delivery.candlesticks(;
    name     = "DOGE_USDT_20260410",
    settle   = Gateio.API.V4.Delivery.Candlesticks.Settle.usdt,
    interval = Gateio.API.V4.Delivery.Candlesticks.TimeInterval.d1,
)
```
"""
function candlesticks(client::GateioClient, query::CandlesticksQuery)
    return APIsRequest{Vector{CandlesticksData}}("GET", "api/v4/delivery/$(query.settle)/candlesticks", query)(client)
end

function candlesticks(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return candlesticks(client, CandlesticksQuery(; kw...))
end

end
