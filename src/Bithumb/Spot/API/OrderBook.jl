module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bithumb
using CryptoAPIs.Bithumb: Data
using CryptoAPIs: Maybe, APIsRequest
import CryptoAPIs: prepare_json!

Base.@kwdef struct OrderBookQuery <: BithumbPublicQuery
    count::Maybe{Int64} = nothing
    order_currency::Maybe{String} = "ALL"
    payment_currency::String
end

Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:order_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:payment_currency}) = true

struct Level
    price::Float64
    quantity::Float64
end

struct OrderBookData <: BithumbData
    asks::Vector{Level}
    bids::Vector{Level}
    order_currency::String
    payment_currency::String
    timestamp::NanoDate
end

function prepare_json!(::Type{T}, json::Dict{String,Any}) where {T<:Data{Dict{String,OrderBookData}}}
    for (_, item) in json["data"]
        if item isa AbstractDict
            item["payment_currency"] = json["data"]["payment_currency"]
            item["timestamp"] = json["data"]["timestamp"]
        end
    end
    delete!(json["data"], "payment_currency")
    delete!(json["data"], "timestamp")
    return json
end

"""
    order_book(client::BithumbClient, query::OrderBookQuery)
    order_book(client::BithumbClient = Bithumb.Spot.public_client; kw...)

  Provides exchange quote information.

[`GET /public/orderbook/{order_currency}_{payment_currency}`](https://apidocs.bithumb.com/reference/%ED%98%B8%EA%B0%80-%EC%A0%95%EB%B3%B4-%EC%A1%B0%ED%9A%8C)

## Parameters:

| Parameter        | Type   | Required | Description    |
|:-----------------|:-------|:---------|:---------------|
| payment_currency | String | true     |                |
| count            | Int64  | false    |                |
| order_currency   | String | false    | Default: "ALL" |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bithumb

result = Bithumb.Spot.order_book(;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 5,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"0000",
  "date":null,
  "data":{
    "asks":[
      {
        "price":8.6553e7,
        "quantity":0.0011
      },
      ...
    ],
    "bids":[
      {
        "price":8.6502e7,
        "quantity":0.0393
      },
      ...
    ],
    "order_currency":"BTC",
    "payment_currency":"KRW",
    "timestamp":"2024-05-14T22:40:07.140999936"
  }
}
```
"""
function order_book(client::BithumbClient, query::OrderBookQuery)
    T = query.order_currency == "ALL" ? Dict{String,OrderBookData} : OrderBookData
    return APIsRequest{Data{T}}("GET", "public/orderbook/$(query.order_currency)_$(query.payment_currency)", query)(client)
end

function order_book(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
