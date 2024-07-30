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
    E::NanoDate             # Message output time
    T::NanoDate             # Transaction time
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
    pair::String
    symbol::String
end

"""
    order_book(client::BinanceClient, query::OrderBookQuery)
    order_book(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
Gets current exchange orders.  
[`GET dapi/v1/depth`](https://binance-docs.github.io/apidocs/delivery/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.CoinMFutures.order_book(;
    symbol = "ADAUSD_PERP",
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "E":"2024-03-21T22:59:25.734000128",
  "T":"2024-03-21T22:59:25.724999936",
  "asks":[
    {
      "price":0.6312,
      "size":1140.0
    },
    ...
  ],
  "symbol":"ADAUSD_PERP",
  "lastUpdateId":895428654926,
  "bids":[
    {
      "price":0.6311,
      "size":9.0
    },
    ...
  ],
  "pair":"ADAUSD"
}
```
"""
function order_book(client::BinanceClient, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "dapi/v1/depth", query)(client)
end

function order_book(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
