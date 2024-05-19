module OrderBook

export OrderBookQuery,
    OrderBookData,
    order_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Deribit
using CryptoAPIs.Deribit: Data
using CryptoAPIs: Maybe, APIsRequest

@enum Depth begin
    ONE          = 1
    FIVE         = 5
    TEN          = 10
    TWENTY       = 20
    FIFTY        = 50
    ONE_HUNDRED  = 100
    THOUSAND     = 1000
    TEN_THOUSAND = 10000
end

Base.@kwdef struct OrderBookQuery <: DeribitPublicQuery
    instrument_name::String
    depth::Maybe{Depth} = nothing
end

function Serde.ser_type(::Type{OrderBookQuery}, x::Depth)::Int64
    return Int64(x)
end

struct Level <: DeribitData
    amount::Float64
    price::Float64
end

struct Greeks <: DeribitData
    delta::Float64
    gamma::Float64
    rho::Float64
    theta::Float64
    vega::Float64
end

struct Stats <: DeribitData
    high::Maybe{Float64}
    low::Maybe{Float64}
    price_change::Maybe{Float64}
    volume::Float64
    volume_usd::Float64
end

struct OrderBookData <: DeribitData
    ask_iv::Maybe{Float64}
    asks::Vector{Level}
    best_ask_amount::Float64
    best_ask_price::Float64
    best_bid_amount::Float64
    best_bid_price::Float64
    bid_iv::Maybe{Float64}
    bids::Vector{Level}
    change_id::Int64
    current_funding::Maybe{Float64}
    delivery_price::Maybe{Float64}
    estimated_delivery_price::Float64
    funding_8h::Maybe{Float64}
    greeks::Maybe{Greeks}
    index_price::Float64
    instrument_name::String
    interest_rate::Maybe{Float64}
    last_price::Maybe{Float64}
    mark_iv::Maybe{Float64}
    mark_price::Float64
    max_price::Float64
    min_price::Float64
    open_interest::Float64
    settlement_price::Maybe{Float64}
    state::String
    stats::Stats
    timestamp::NanoDate
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
end

"""
    order_book(client::DeribitClient, query::OrderBookQuery)
    order_book(client::DeribitClient = Deribit.Common.public_client; kw...)

Retrieves the order book, along with other market values for a given instrument.

[`GET api/v2/public/get_order_book`](https://docs.deribit.com/#public-get_order_book)

## Parameters:

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| instrument_name | String | true     |             |
| depth           | Depth  | false    | `ONE` (1), `FIVE` (5), `TEN` (10), `TWENTY` (20), `FIFTY` (50), `ONE_HUNDRED` (100), `THOUSAND` (1000), `TEN_THOUSAND` (10000) |

## Code samples:

```julia
using Serde
using CryptoAPIs.Deribit

result = Deribit.Common.order_book(;
    instrument_name = "BTC-PERPETUAL",
    depth = CryptoAPIs.Deribit.Common.OrderBook.TEN,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":null,
  "jsonrpc":"2.0",
  "testnet":false,
  "usDiff":808,
  "usOut":"2024-05-17T12:09:18.775115008",
  "usIn":"2024-05-17T12:09:18.774307072",
  "result":{
    "ask_iv":null,
    "asks":[
      {
        "amount":66265.0,
        "price":164430.0
      },
      ...
    ],
    "best_ask_amount":164430.0,
    "best_ask_price":66265.0,
    "best_bid_amount":116100.0,
    "best_bid_price":66264.5,
    "bid_iv":null,
    "bids":[
      {
        "amount":66264.5,
        "price":116100.0
      },
      ...
    ],
    "change_id":70662452234,
    "current_funding":1.733e-5,
    "delivery_price":null,
    "estimated_delivery_price":66247.85,
    "funding_8h":2.696e-5,
    "greeks":null,
    "index_price":66247.85,
    "instrument_name":"BTC-PERPETUAL",
    "interest_rate":null,
    "last_price":66264.5,
    "mark_iv":null,
    "mark_price":66265.56,
    "max_price":68254.0,
    "min_price":64277.5,
    "open_interest":7.0092997e8,
    "settlement_price":66421.48,
    "state":"open",
    "stats":{
      "high":66798.0,
      "low":64620.5,
      "price_change":0.0521,
      "volume":9341.58521281,
      "volume_usd":6.1459374e8
    },
    "timestamp":"2024-05-17T12:09:18.761999872",
    "underlying_index":null,
    "underlying_price":null
  }
}
```
"""
function order_book(client::DeribitClient, query::OrderBookQuery)
    return APIsRequest{Data{OrderBookData}}("GET", "api/v2/public/get_order_book", query)(client)
end

function order_book(client::DeribitClient = Deribit.Common.public_client; kw...)
    return order_book(client, OrderBookQuery(; kw...))
end

end
