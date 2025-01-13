module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Category SPOT LINEAR INVERSE
@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

Base.@kwdef struct CandleQuery <: BybitPublicQuery
    category::Category
    symbol::String
    interval::TimeInterval
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::Category)::String
  x == SPOT    && return "spot"
  x == LINEAR  && return "linear"
  x == INVERSE && return "inverse"
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1"
    x == m3  && return "3"
    x == m5  && return "5"
    x == m15 && return "15"
    x == m30 && return "30"
    x == h1  && return "60"
    x == h2  && return "120"
    x == h4  && return "240"
    x == h6  && return "360"
    x == h12 && return "720"
    x == d1  && return "D"
    x == w1  && return "W"
    x == M1  && return "M"
end

struct CandleData <: BybitData
    start::Maybe{NanoDate}
    open::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    close::Maybe{Float64}
    volume::Maybe{Float64}
    turnover::Maybe{Float64}
end

"""
    candle(client::BybitClient, query::CandleQuery)
    candle(client::BybitClient = Bybit.Spot.public_client; kw...)

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

result = Bybit.Spot.candle(;
    category = Bybit.Spot.Candle.SPOT,
    symbol = "ADAUSDT",
    interval = Bybit.Spot.Candle.M1,
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
function candle(client::BybitClient, query::CandleQuery)
    return APIsRequest{Data{List{CandleData}}}("GET", "/v5/market/kline", query)(client)
end

function candle(client::BybitClient = Bybit.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
