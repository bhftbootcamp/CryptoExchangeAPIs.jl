module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Precision P0 P1 P2 P3 P4 R0

@enum OrderBookLength begin
    ONE = 1
    TWENTY_FIVE = 25
    ONE_HUNDRED = 100
end

Base.@kwdef struct OrderBookQuery <: BitfinexPublicQuery
    symbol::String
    precision::Precision
    len::OrderBookLength = ONE
end

function Serde.ser_type(::Type{OrderBookQuery}, x::OrderBookLength)::Int64
    return Int64(x)
end

Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:symbol}) = true
Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:precision}) = true

struct OrderBookData <: BitfinexData
    price::Float64
    count::Int64
    amount::Float64
end

"""
    order_book(client::BitfinexClient, query::OrderBookQuery)
    order_book(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)

The Public Books endpoint allows you to keep track of the state of Bitfinex order books on a price aggregated basis with customizable precision.
Raw books can be retrieved by using precision `R0`.

[`GET v2/book/{symbol}/{precision}`](https://docs.bitfinex.com/reference/rest-public-book)

## Parameters:

| Parameter | Type            | Required | Description |
|:----------|:----------------|:---------|:------------|
| symbol    | String          | true     |             |
| precision | Precision       | true     | `P0` `P1` `P2` `P3` `P4` `R0` |
| len       | OrderBookLength | false    | Default: `ONE` (1), Available: `TWENTY_FIVE` (25), `ONE_HUNDRED` (100). |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.Spot.order_book(;
    symbol = "tBTCUSD",
    precision = CryptoExchangeAPIs.Bitfinex.Spot.OrderBook.P1,
    len = CryptoExchangeAPIs.Bitfinex.Spot.OrderBook.TWENTY_FIVE,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "price":67070.0,
    "count":4,
    "amount":0.16776825
  },
  ...
]
```
"""
function order_book(client::BitfinexClient, query::OrderBookQuery)
    return APIsRequest{Vector{OrderBookData}}("GET", "v2/book/$(query.symbol)/$(query.precision)", query)(client)
end

function order_book(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
