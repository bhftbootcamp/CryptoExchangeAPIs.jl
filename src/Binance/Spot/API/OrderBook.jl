module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: BinanceData
    price::Float64
    size::Float64
end

struct OrderBookData <: BinanceData
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
end

"""
    order_book(client::BinanceClient, query::OrderBookQuery)
    order_book(client::BinanceClient = Binance.Spot.public_client; kw...)

[`GET api/v3/depth`](https://binance-docs.github.io/apidocs/spot/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.Spot.order_book(;
    symbol = "ADAUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asks":[
    {
      "price":0.634,
      "size":1478.6
    },
    ...
  ],
  "bids":[
    {
      "price":0.6339,
      "size":28448.6
    },
    ...
  ],
  "lastUpdateId":8394873195
}
```
"""
function order_book(client::BinanceClient, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "api/v3/depth", query)(client)
end

function order_book(client::BinanceClient = Binance.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
