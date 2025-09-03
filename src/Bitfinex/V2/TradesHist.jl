module TradesHist

export TradesHistQuery,
    TradesHistData,
    trades_hist

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TradesHistQuery <: BitfinexPublicQuery
    symbol::String
    _end::Maybe{DateTime} = nothing
    limit::Int64 = 125
    start::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TradesHistQuery}, ::Val{:symbol}) = true

struct TradesHistData <: BitfinexData
    ID::Int64
    timestamp::NanoDate
    amount::Float64
    price::Float64
end

"""
    trades_hist(client::BitfinexClient, query::TradesHistQuery)
    trades_hist(client::BitfinexClient = Bitfinex.public_client; kw...)

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
using Dates
using Serde
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.V2.trades_hist(;
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
function trades_hist(client::BitfinexClient, query::TradesHistQuery)
    return APIsRequest{Vector{TradesHistData}}("GET", "v2/trades/$(query.symbol)/hist", query)(client)
end

function trades_hist(client::BitfinexClient = Bitfinex.public_client; kw...)
    return trades_hist(client, TradesHistQuery(; kw...))
end

end
