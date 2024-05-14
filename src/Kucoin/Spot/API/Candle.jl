module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kucoin
using CryptoAPIs.Kucoin: Data, Page
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 w1

Base.@kwdef struct CandleQuery <: KucoinPublicQuery
    symbol::String
    type::TimeInterval
    endAt::Maybe{DateTime} = nothing
    startAt::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1min"
    x == m3  && return "3min"
    x == m5  && return "5min"
    x == m15 && return "15min"
    x == m30 && return "30min"
    x == h1  && return "1hour"
    x == h2  && return "2hour"
    x == h4  && return "4hour"
    x == h6  && return "6hour"
    x == h8  && return "8hour"
    x == h12 && return "12hour"
    x == d1  && return "1day"
    x == w1  && return "1week"
end

struct CandleData <: KucoinData
    time::Maybe{NanoDate}
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
    turnover::Maybe{Float64}
end

"""
    candle(client::KucoinClient, query::CandleQuery)
    candle(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get the kline of the specified symbol.

[`GET api/v1/market/candles`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-klines)

## Parameters:

| Parameter | Type         | Required | Description                               |
|:----------|:-------------|:---------|:------------------------------------------|
| symbol    | String       | true     |                                           |
| type      | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 w1 |
| endAt     | DateTime     | false    |                                           |
| startAt   | DateTime     | false    |                                           |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kucoin

result = Kucoin.Spot.candle(;
    symbol = "BTC-USDT",
    type = Kucoin.Spot.Candle.m1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200000,
  "data":[
    {
      "time":"2024-05-14T10:37:00",
      "open":61665.9,
      "close":61676.4,
      "high":61676.4,
      "low":61660.3,
      "volume":0.61931855,
      "turnover":38189.806617378
    },
    ...
  ]
}
```
"""
function candle(client::KucoinClient, query::CandleQuery)
    return APIsRequest{Data{Vector{CandleData}}}("GET", "api/v1/market/candles", query)(client)
end

function candle(client::KucoinClient = Kucoin.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
