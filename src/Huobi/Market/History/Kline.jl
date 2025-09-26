module Kline

export KlineQuery,
    KlineData,
    kline

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m15 m30 m60 h4 d1 M1 Y1

Base.@kwdef struct KlineQuery <: HuobiPublicQuery
    period::TimeInterval.T
    symbol::String
    size::Int64 = 150       # Default size 150 [1-2000]
end

function Serde.ser_type(::Type{<:KlineQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1min"
    x == TimeInterval.m5  && return "5min"
    x == TimeInterval.m15 && return "15min"
    x == TimeInterval.m30 && return "30min"
    x == TimeInterval.h1  && return "60min"
    x == TimeInterval.h4  && return "4hour"
    x == TimeInterval.d1  && return "1day"
    x == TimeInterval.M1  && return "1mon"
    x == TimeInterval.Y1  && return "1year"
end

struct KlineData <: HuobiData
    amount::Maybe{Float64}
    close::Maybe{Float64}
    count::Maybe{Int64}
    high::Maybe{Float64}
    id::NanoDate
    low::Maybe{Float64}
    open::Maybe{Float64}
    vol::Maybe{Float64}
end

"""
    kline(client::HuobiClient, query::KlineQuery)
    kline(client::HuobiClient = Huobi.Spot.public_client; kw...)

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
using CryptoExchangeAPIs.Huobi

result = Huobi.Spot.kline(;
    symbol = "btcusdt",
    period = CryptoExchangeAPIs.Huobi.Spot.Kline.m1,
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
function kline(client::HuobiClient, query::KlineQuery)
    return APIsRequest{Data{Vector{KlineData}}}("GET", "market/history/kline", query)(client)
end

function kline(client::HuobiClient = Huobi.public_client; kw...)
    return kline(client, KlineQuery(; kw...))
end

end
