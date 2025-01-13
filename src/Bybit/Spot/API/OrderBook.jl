module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct OrderBookQuery <: BybitPublicQuery
    category::Category
    symbol::String
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:OrderBookQuery}, x::Category)::String
  x == OPTION  && return "option"
  x == SPOT    && return "spot"
  x == LINEAR  && return "linear"
  x == INVERSE && return "inverse"
end

struct Level <: BybitData
    price::Float64
    size::Float64
end

struct OrderBookData <: BybitData
    s::String
    a::Vector{Level}
    b::Vector{Level}
    ts::NanoDate
end

"""
    order_book(client::BybitClient, query::OrderBookQuery)
    order_book(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /v5/market/orderbook`](https://bybit-exchange.github.io/docs/v5/market/orderbook)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:-------------------------- |
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | true     |                            |
| limit     | Int64    | false    |                            |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Spot.order_book(;
    category = Bybit.Spot.OrderBook.SPOT,
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
    "s":"ADAUSDT",
    "a":[
      {
        "price":0.9064,
        "size":96.0
      }
    ],
    "b":[
      {
        "price":0.9062,
        "size":1951.28
      }
    ],
    "ts":"2025-01-13T11:35:23.236999936"
  },
  "retExtInfo":{
    
  },
  "time":"2025-01-13T11:35:23.382000128"
}
```
"""
function order_book(client::BybitClient, query::OrderBookQuery)
    return APIsRequest{Data{OrderBookData}}("GET", "/v5/market/orderbook", query)(client)
end

function order_book(client::BybitClient = Bybit.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
