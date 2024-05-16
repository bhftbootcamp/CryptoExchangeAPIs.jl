module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Huobi
using CryptoAPIs.Huobi: Data
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m15 m30 m60 h4 d1 M1 Y1

Base.@kwdef struct CandleQuery <: HuobiPublicQuery
    period::TimeInterval
    symbol::String
    size::Int64 = 150       # The number of data returns default 150 [1-2000]
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1min"
    x == m5  && return "5min"
    x == m15 && return "15min"
    x == m30 && return "30min"
    x == h1  && return "60min"
    x == h4  && return "4hour"
    x == d1  && return "1day"
    x == M1  && return "1mon"
    x == Y1  && return "1year"
end

struct CandleData <: HuobiData
    amount::Maybe{Float64}
    close::Maybe{Float64}
    count::Maybe{Int64}
    high::Maybe{Float64}
    id::Maybe{NanoDate}
    low::Maybe{Float64}
    open::Maybe{Float64}
    vol::Maybe{Float64}
end

"""
    candle(client::HuobiClient, query::CandleQuery)
    candle(client::HuobiClient = Huobi.Spot.public_client; kw...)

This endpoint retrieves all klines in a specific range.

[`GET market/history/kline`](https://huobiapi.github.io/docs/spot/v1/en/#get-klines-candles)

## Parameters:

| Parameter | Type         | Required | Description    |
|:----------|:-------------|:---------|:---------------|
| period    | TimeInterval | true     |                |
| symbol    | String       | true     |                |
| size      | Int64        | false    | Default: `150` |

## Code samples:

```julia
using Serde
using CryptoAPIs.Huobi

result = Huobi.Spot.candle(;
    symbol = "btcusdt",
    period = CryptoAPIs.Huobi.Spot.Candle.m1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "ch":"market.btcusdt.kline.1min",
  "ts":"2024-05-16T12:50:25.071000064",
  "code":null,
  "data":[
    {
      "amount":0.298096,
      "close":66300.0,
      "count":34,
      "high":66318.86,
      "id":"2024-05-16T12:50:00",
      "low":66268.18,
      "open":66268.18,
      "vol":19766.85497792
    },
    ...
  ]
}
```
"""
function candle(client::HuobiClient, query::CandleQuery)
    return APIsRequest{Data{Vector{CandleData}}}("GET", "market/history/kline", query)(client)
end

function candle(client::HuobiClient = Huobi.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
