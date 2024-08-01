module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: BybitPublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: BybitData
    price::Float64
    size::Float64
end

struct OrderBookData <: BybitData
    asks::Vector{Level}
    bids::Vector{Level}
    time::NanoDate
end

"""
    order_book(client::BybitClient, query::OrderBookQuery)
    order_book(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /spot/v3/public/quote/depth`](https://bybit-exchange.github.io/docs/spot/public/depth)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Spot.order_book(;
    symbol = "ADAUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "asks":[
      {
        "price":0.6627,
        "size":2144.17
      },
      ...
    ],
    "bids":[
      {
        "price":0.6625,
        "size":447.02
      },
      ...
    ],
    "time":"2024-03-25T18:48:45.454000128"
  },
  "retExtInfo":{},
  "time":"2024-03-25T18:48:45.454000128"
}
```
"""
function order_book(client::BybitClient, query::OrderBookQuery)
    return APIsRequest{Data{OrderBookData}}("GET", "/spot/v3/public/quote/depth", query)(client)
end

function order_book(client::BybitClient = Bybit.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
