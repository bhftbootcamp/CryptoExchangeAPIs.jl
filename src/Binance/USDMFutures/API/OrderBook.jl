module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: BinanceData
    price::Float64
    size::Float64
end

struct OrderBookData <: BinanceData
    E::NanoDate             # Message output time
    T::NanoDate             # Transaction time
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
end

"""
    order_book(client::BinanceClient, query::OrderBookQuery)
    order_book(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET fapi/v1/depth`](https://binance-docs.github.io/apidocs/futures/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.order_book(;
    symbol = "ADAUSDT"
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "T":"2024-03-21T21:25:53.671000064",
  "E":"2024-03-21T21:25:53.680999936",
  "asks":[
    {
      "price":0.6337,
      "size":20325.0
    },
    ...
  ],
  "lastUpdateId":4248628084740,
  "bids":[
    {
      "price":0.6336,
      "size":58607.0
    },
    ...
  ]
}
```
"""
function order_book(client::BinanceClient, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "fapi/v1/depth", query)(client)
end

function order_book(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
