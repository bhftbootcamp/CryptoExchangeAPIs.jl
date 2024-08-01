module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: DataTick
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum StepType begin
    step0 # step0 No market depth aggregation
    step1 # step1 Aggregation level = precision*10
    step2 # step2 Aggregation level = precision*100
    step3 # step3 Aggregation level = precision*1000
    step4 # step4 Aggregation level = precision*10000
    step5 # step5 Aggregation level = precision*100000
end

Base.@kwdef struct OrderBookQuery <: HuobiPublicQuery
    symbol::String
    depth::Maybe{Int64} = nothing
    type::StepType = step0
end

struct Level
    price::Float64
    size::Float64
end

struct OrderBookData <: HuobiData
    asks::Vector{Level}
    bids::Vector{Level}
    ts::NanoDate
    version::Int64
end

"""
    order_book(client::HuobiClient, query::OrderBookQuery)
    order_book(client::HuobiClient = Huobi.Spot.public_client; kw...)

This endpoint retrieves the current order book of a specific pair.

[`GET market/depth`](https://huobiapi.github.io/docs/spot/v1/en/#get-market-depth)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| depth     | Int64    | false    |             |
| type      | StepType | false    | Default: `step0`, Available: `step1`, `step2`, `step3`, `step4`, `step5` |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Huobi

result = Huobi.Spot.order_book(;
    symbol = "btcusdt",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "ch":"market.btcusdt.depth.step0",
  "ts":"2024-05-16T12:57:01.596999936",
  "tick":{
    "asks":[
      {
        "price":66089.57,
        "size":0.256781
      },
      ...
    ],
    "bids":[
      {
        "price":66089.56,
        "size":0.170774
      },
      ...
    ],
    "ts":"2024-05-16T12:57:01.400999936",
    "version":170820034651
  }
}
```
"""
function order_book(client::HuobiClient, query::OrderBookQuery)
    return APIsRequest{DataTick{OrderBookData}}("GET", "market/depth", query)(client)
end

function order_book(client::HuobiClient = Huobi.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
