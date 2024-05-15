module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: KrakenPublicQuery
    pair::String
    count::Maybe{Int64} = nothing
end

struct OrderBookLevel <: KrakenData
    price::Float64
    volume::Float64
    timestamp::NanoDate
end

struct OrderBookData <: KrakenData
    asks::Vector{OrderBookLevel}
    bids::Vector{OrderBookLevel}
end

function Serde.deser(::Type{OrderBookLevel}, x::Vector{Any})::OrderBookLevel
    return OrderBookLevel(
        tryparse(Float64, x[1]),
        tryparse(Float64, x[2]),
        unix2datetime(x[3]),
    )
end

"""
    order_book(client::KrakenClient, query::OrderBookQuery)
    order_book(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get current order book details.

[`POST 0/public/Depth`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getOrderBook)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| pair      | String     | true     |             |
| count     | Int64      | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kraken

result = Kraken.Spot.order_book(;
    pair = "XBTUSD",
    count = 10,
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "XXBTZUSD":{
      "asks":[
        {
          "price":64880.3,
          "volume":10.817,
          "timestamp":"2024-05-15T17:22:08"
        },
        ...
      ],
      "bids":[
        {
          "price":64880.2,
          "volume":0.917,
          "timestamp":"2024-05-15T17:22:08"
        },
        ...
      ]
    }
  }
}
```
"""
function order_book(client::KrakenClient, query::OrderBookQuery)
    return APIsRequest{Data{Dict{String,OrderBookData}}}("GET", "0/public/Depth", query)(client)
end

function order_book(client::KrakenClient = Kraken.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
