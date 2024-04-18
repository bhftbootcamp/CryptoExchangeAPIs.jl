module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

@enum Settle btc usdt usd

Base.@kwdef struct OrderBookQuery <: GateioPublicQuery
    contract::String
    interval::Maybe{String} = nothing
    limit::Maybe{Int64} = nothing
    with_id::Maybe{Bool} = nothing
end

struct Order <: GateioData
    p::String
    s::Int64
end

struct OrderBookData <: GateioData
    id::Maybe{Int64}
    current::Float64
    update::Float64
    asks::Vector{Order}
    bids::Vector{Order}
end

"""
    order_book(client::GateioClient, query::OrderBookQuery)
    order_book(client::GateioClient = Gateio.Futures.public_client; kw...)

Futures order book.

[`GET api/v4/futures/{settle}/order_book`](https://www.gate.io/docs/developers/apiv4/en/#futures-order-book)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| contract  | String   | true     |             |
| interval  | String   | false    |             |
| limit     | Int64    | false    |             |
| with_id   | Bool     | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Gateio

result = Gateio.Futures.order_book(; 
    settle = Gateio.Futures.OrderBook.usdt,
    contract = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":null,
  "current":1.713214908609e9,
  "update":1.713214908589e9,
  "asks":[
    {
      "p":"63167.4",
      "s":1903
    },
    ...
  ],
  "bids":[
    {
      "p":"63167.3",
      "s":10650
    },
    ...
  ]
}
```
"""
function order_book(client::GateioClient, settle::Settle, query::OrderBookQuery)
    return APIsRequest{OrderBookData}("GET", "api/v4/futures/$settle/order_book", query)(client)
end

function order_book(client::GateioClient = Gateio.Futures.public_client; settle::Settle, kw...)
    return order_book(client, settle, OrderBookQuery(; kw...))
end

end
