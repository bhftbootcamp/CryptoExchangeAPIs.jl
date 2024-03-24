module OrderBook 

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

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
    orderbook(client::UpbitClient, query::OrderBookQuery)
    orderbook(client::UpbitClient = Upbit.Spot.public_client; kw...)

Order book data

[`GET v1/orderbook`](https://docs.upbit.com/reference/호가-정보-조회)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| markets   | String   | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Upbit

result = Upbit.Spot.orderbook(;
    markets = "KRW-BTC"
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market": "KRW-BTC",
    "timestamp": 1704871103076,
    "total_ask_size": 7.94842375,
    "total_bid_size": 23.1093401,
    "orderbook_units": [
      {
        "ask_price": 61820000,
        "bid_price": 61810000,
        "ask_size": 0.89263296,
        "bid_size": 2.20305622
      },
      {
        "ask_price": 61830000,
        "bid_price": 61800000,
        "ask_size": 0.22832604,
        "bid_size": 1.35301971
      },
      {
        "ask_price": 61840000,
        "bid_price": 61790000,
        "ask_size": 0.05424416,
        "bid_size": 0.76573538
      },
      {
        "ask_price": 61850000,
        "bid_price": 61780000,
        "ask_size": 0.23470545,
        "bid_size": 2.92881015
      },
      {
        "ask_price": 61860000,
        "bid_price": 61770000,
        "ask_size": 2.74191112,
        "bid_size": 0.60136
      },
      {
        "ask_price": 61870000,
        "bid_price": 61760000,
        "ask_size": 0.0002274,
        "bid_size": 0.39492601
      },
      {
        "ask_price": 61880000,
        "bid_price": 61750000,
        "ask_size": 0.27063798,
        "bid_size": 0.78862322
      },
      {
        "ask_price": 61890000,
        "bid_price": 61740000,
        "ask_size": 0.33411921,
        "bid_size": 1.39555883
      },
      {
        "ask_price": 61900000,
        "bid_price": 61730000,
        "ask_size": 0.17051798,
        "bid_size": 0.39231214
      },
      {
        "ask_price": 61910000,
        "bid_price": 61720000,
        "ask_size": 0.12104401,
        "bid_size": 6.05195548
      },
      {
        "ask_price": 61920000,
        "bid_price": 61710000,
        "ask_size": 2.60161551,
        "bid_size": 1.14584663
      },
      {
        "ask_price": 61930000,
        "bid_price": 61700000,
        "ask_size": 0.018,
        "bid_size": 2.01343324
      },
      {
        "ask_price": 61940000,
        "bid_price": 61690000,
        "ask_size": 0.00080733,
        "bid_size": 2.19357468
      },
      {
        "ask_price": 61950000,
        "bid_price": 61680000,
        "ask_size": 0.03432701,
        "bid_size": 0.29973438
      },
      {
        "ask_price": 61960000,
        "bid_price": 61670000,
        "ask_size": 0.24530759,
        "bid_size": 0.58139403
      }
    ],
    "level": 10000
  }
]
```
"""
function orderbook(client::UpbitClient, query::OrderBookQuery)
    return APIsRequest{Vector{OrderBookData}}("GET", "v1/orderbook", query)(client)
end

function orderbook(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return orderbook(client, OrderBookQuery(; kw...))
end

end
