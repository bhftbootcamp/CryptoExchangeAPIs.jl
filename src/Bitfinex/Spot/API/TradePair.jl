module TradePair

export TradePairQuery,
    TradePairData,
    trade_pair

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TradePairQuery <: BitfinexPublicQuery
    symbol::String
    _end::Maybe{DateTime} = nothing
    limit::Int64 = 125
    start::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TradePairQuery}, ::Val{:symbol}) = true

struct TradePairData <: BitfinexData
    ID::Int64
    timestamp::NanoDate
    amount::Float64
    price::Float64
end

"""
    trade_pair(client::BitfinexClient, query::TradePairQuery)
    trade_pair(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)

The trades endpoint allows the retrieval of past public trades and includes details such as price, size, and time.
Optional parameters can be used to limit the number of results; you can specify a start and end timestamp, a limit, and a sorting method.

[`GET v2/trades/{symbol}/hist`](https://docs.bitfinex.com/reference/rest-public-trades)

## Parameters:

| Parameter | Type     | Required | Description    |
|:----------|:---------|:---------|:---------------|
| symbol    | String   | true     |                |
| start     | DateTime | false    |                |
| _end      | DateTime | false    |                |
| limit     | Int64    | false    | Default: `125` |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.Spot.trade_pair(;
    symbol = "tBTCUSD",
    start = DateTime("2024-03-17T12:00:00"),
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "ID":1610094512,
    "timestamp":"2024-05-19T14:40:03.928",
    "amount":0.00093888,
    "price":67041.0
  },
  ...
]
```
"""
function trade_pair(client::BitfinexClient, query::TradePairQuery)
    return APIsRequest{Vector{TradePairData}}("GET", "v2/trades/$(query.symbol)/hist", query)(client)
end

function trade_pair(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)
    return trade_pair(client, TradePairQuery(; kw...))
end

end
