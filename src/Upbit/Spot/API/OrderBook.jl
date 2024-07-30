module OrderBook 

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: UpbitPublicQuery
    markets::String
end

struct OrderBookUnit <: UpbitData
    ask_price::Float64
    ask_size::Float64
    bid_price::Float64
    bid_size::Float64
end

struct OrderBookData <: UpbitData
    market::String
    orderbook_units::Vector{OrderBookUnit}
    timestamp::NanoDate
    total_ask_size::Float64
    total_bid_size::Float64
end

"""
    order_book(client::UpbitClient, query::OrderBookQuery)
    order_book(client::UpbitClient = Upbit.Spot.public_client; kw...)

Order book data

[`GET v1/orderbook`](https://docs.upbit.com/reference/호가-정보-조회)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| markets   | String   | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Upbit

result = Upbit.Spot.order_book(;
    markets = "KRW-BTC"
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market":"KRW-BTC",
    "orderbook_units":[
      {
        "ask_price":9.6234e7,
        "ask_size":0.00612883,
        "bid_price":9.6228e7,
        "bid_size":0.36973888
      },
      ...
    ],
    "timestamp":"2024-03-25T10:34:07.163000064",
    "total_ask_size":1.74427302,
    "total_bid_size":1.46524011
  }
]
```
"""
function order_book(client::UpbitClient, query::OrderBookQuery)
    return APIsRequest{Vector{OrderBookData}}("GET", "v1/orderbook", query)(client)
end

function order_book(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
