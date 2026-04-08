module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderBookQuery <: MexcPublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: MexcData
    price::Float64
    size::Float64
end

struct OrderBookData <: MexcData
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Maybe{Int64}
end

"""
    order_book(client::MexcClient, query::OrderBookQuery)
    order_book(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)

Order book depth.

[`GET api/v3/depth`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description                   |
|:----------|:-------|:---------|:------------------------------|
| symbol    | String | true     |                               |
| limit     | Int64  | false    | Default 100; max 5000         |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.order_book(;
    symbol = "BTCUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asks":[
    {
      "price":46260.41,
      "size":1.0
    },
    ...
  ],
  "bids":[
    {
      "price":46260.38,
      "size":2.0
    },
    ...
  ],
  "lastUpdateId":1112416
}
```
"""
function order_book(client::MexcClient, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "api/v3/depth", query)(client)
end

function order_book(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
