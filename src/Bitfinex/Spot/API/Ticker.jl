module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bitfinex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: BitfinexPublicQuery
    symbols::String = "ALL"
end

struct TickerData <: BitfinexData
    symbol::String
    bid::Maybe{Float64}
    bidSize::Maybe{Float64}
    ask::Maybe{Float64}
    askSize::Maybe{Float64}
    dailyChange::Maybe{Float64}
    dailyChangeRelative::Maybe{Float64}
    lastPrice::Maybe{Float64}
    volume::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
end

"""
    ticker(client::BitfinexClient, query::TickerQuery)
    ticker(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)

The tickers endpoint provides a high level overview of the state of the market.
It shows the current best bid and ask, the last traded price, as well as information on the daily volume and price movement over the last day.
The endpoint can retrieve multiple tickers with a single query.

[`GET v2/tickers`](https://docs.bitfinex.com/reference/rest-public-tickers)

## Parameters:

| Parameter | Type   | Required | Description      |
|:----------|:-------|:---------|:-----------------|
| symbols   | String | false    | Default: `"ALL"` |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bitfinex

result = Bitfinex.Spot.ticker(;
    symbols = "tBTCUSD"
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"tBTCUSD",
    "bid":67071.0,
    "bidSize":5.38418309,
    "ask":67072.0,
    "askSize":8.43368794,
    "dailyChange":194.0,
    "dailyChangeRelative":0.00290133,
    "lastPrice":67060.0,
    "volume":220.21828778,
    "high":67801.0,
    "low":66677.0
  }
]
```
"""
function ticker(client::BitfinexClient, query::TickerQuery)
    return APIsRequest{Vector{TickerData}}("GET", "v2/tickers", query)(client)
end

function ticker(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
