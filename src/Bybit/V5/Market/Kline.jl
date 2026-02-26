module Kline

export KlineQuery,
    KlineData,
    kline

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category spot linear inverse
@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 w1 M1

Base.@kwdef struct KlineQuery <: BybitPublicQuery
    category::Category.T
    symbol::String
    interval::TimeInterval.T
    _end::Maybe{DateTime} = nothing
    start::Maybe{DateTime} = nothing
    limit::Maybe{Int} = nothing
end

Serde.SerQuery.ser_name(::Type{<:KlineQuery}, ::Val{:_end}) = "end"

function Serde.ser_type(::Type{<:KlineQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1"
    x == TimeInterval.m3  && return "3"
    x == TimeInterval.m5  && return "5"
    x == TimeInterval.m15 && return "15"
    x == TimeInterval.m30 && return "30"
    x == TimeInterval.h1  && return "60"
    x == TimeInterval.h2  && return "120"
    x == TimeInterval.h4  && return "240"
    x == TimeInterval.h6  && return "360"
    x == TimeInterval.h12 && return "720"
    x == TimeInterval.d1  && return "D"
    x == TimeInterval.w1  && return "W"
    x == TimeInterval.M1  && return "M"
end

struct KlineData <: BybitData
    start::NanoDate
    open::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    close::Maybe{Float64}
    volume::Maybe{Float64}
    turnover::Maybe{Float64}
end

"""
    kline(client::BybitClient, query::KlineQuery)
    kline(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

[`GET /v5/market/kline`](https://bybit-exchange.github.io/docs/v5/market/kline)

## Parameters:

| Parameter | Type         | Required | Description                               |
|:----------|:-------------|:---------|:------------------------------------------|
| category  | Category     | true     | spot linear inverse                       |
| symbol    | String       | true     |                                           |
| interval  | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 w1 M1 |
| endTime   | DateTime     | false    |                                           |
| limit     | Int          | false    |                                           |
| startTime | DateTime     | false    |                                           |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.kline(;
    category = Bybit.V5.Market.Kline.Category.spot,
    symbol = "ADAUSDT",
    interval = Bybit.V5.Market.Kline.TimeInterval.M1,
)
```
"""
function kline(client::BybitClient, query::KlineQuery)
    return APIsRequest{Data{List{KlineData}}}("GET", "v5/market/kline", query)(client)
end

function kline(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return kline(client, KlineQuery(; kw...))
end

end
