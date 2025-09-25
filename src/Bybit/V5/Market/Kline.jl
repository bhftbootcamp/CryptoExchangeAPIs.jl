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

@enumx Category SPOT LINEAR INVERSE
@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

Base.@kwdef struct KlineQuery <: BybitPublicQuery
    category::Category.T
    symbol::String
    interval::TimeInterval.T
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:KlineQuery}, x::Category.T)::String
  x == Category.SPOT    && return "spot"
  x == Category.LINEAR  && return "linear"
  x == Category.INVERSE && return "inverse"
end

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
    start::Maybe{NanoDate}
    open::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    close::Maybe{Float64}
    volume::Maybe{Float64}
    turnover::Maybe{Float64}
end

"""
    kline(client::BybitClient, query::KlineQuery)
    kline(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /v5/market/kline`](https://bybit-exchange.github.io/docs/v5/market/kline)

## Parameters:

| Parameter | Type         | Required | Description                               |
|:----------|:-------------|:---------|:------------------------------------------|
| category  | Category     | true     | SPOT LINEAR INVERSE                       |
| symbol    | String       | true     |                                           |
| interval  | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 w1 M1 |
| endTime   | DateTime     | false    |                                           |
| limit     | Int64        | false    |                                           |
| startTime | DateTime     | false    |                                           |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Spot.kline(;
    category = Bybit.Spot.Kline.SPOT,
    symbol = "ADAUSDT",
    interval = Bybit.Spot.Kline.M1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "list":[
      {
        "start":"2025-01-01T00:00:00",
        "open":0.8451,
        "high":1.1519,
        "low":0.8382,
        "close":0.9103,
        "volume":6.6700225827e8,
        "turnover":6.724810699166e8
      },
      ...
    ],
    "nextPageCursor":null,
    "category":"spot"
  },
  "retExtInfo":{},
  "time":"2025-01-13T11:19:18.851000064"
}
```
"""
function kline(client::BybitClient, query::KlineQuery)
    return APIsRequest{Data{List{KlineData}}}("GET", "/v5/market/kline", query)(client)
end

function kline(client::BybitClient = Bybit.public_client; kw...)
    return kline(client, KlineQuery(; kw...))
end

end
