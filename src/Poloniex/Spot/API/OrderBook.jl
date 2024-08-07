module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum OrderBookLimit begin
    FIVE = 5
    TEN = 10
    TWENTY = 20
    FIFTY = 50
    HUNDRED = 100
    HUNDRED_FIFTY = 150
end

Base.@kwdef struct OrderBookQuery <: PoloniexPublicQuery
    symbol::Maybe{String} = nothing
    limit::Maybe{OrderBookLimit} = nothing
    scale::Maybe{Int64} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{OrderBookQuery}, ::Val{:symbol}) = true

function Serde.SerQuery.ser_type(::Type{OrderBookQuery}, x::OrderBookLimit)::Int64
    return Int64(x)
end

struct OrderBookData <: PoloniexData
    asks::Vector{Float64}
    bids::Vector{Float64}
    scale::Float64
    time::NanoDate
    ts::NanoDate
end

"""
    order_book(client::PoloniexClient, query::OrderBookQuery)
    order_book(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get the order book for a given symbol.

[`GET markets/{symbol}/orderBook`](https://api-docs.poloniex.com/spot/api/public/market-data#order-book)

## Parameters:

| Parameter | Type           | Required | Description                                                                                 |
|:----------|:---------------|:---------|:--------------------------------------------------------------------------------------------|
| symbol    | String         | false    |                                                                                             |
| limit     | OrderBookLimit | false    | `FIVE` (5), `TEN` (10), `TWENTY` (20), `FIFTY` (50), `HUNDRED` (100), `HUNDRED_FIFTY` (150) |
| scale     | Int64          | false    |                                                                                             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Spot.order_book(;
    symbol = "BTC_USDT",
    limit = CryptoExchangeAPIs.Poloniex.Spot.OrderBook.FIVE,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asks":[
    65281.6,
    0.047754,
    65289.99,
    0.034131,
    ...
  ],
  "bids":[
    65220.41,
    0.140174,
    65220.4,
    0.004296,
    ...
  ],
  "scale":0.01,
  "time":"2024-05-16T17:07:48.972999936",
  "ts":"2024-05-16T17:07:48.987000064"
}
```
"""
function order_book(client::PoloniexClient, query::OrderBookQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets/orderBook" : "markets/$(query.symbol)/orderBook"
    return APIsRequest{OrderBookData}("GET", endpoint, query)(client)
end

function order_book(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
