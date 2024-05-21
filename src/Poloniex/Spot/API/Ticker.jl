module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Poloniex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: PoloniexPublicQuery
    symbol::Maybe{String} = nothing
end

struct TickerData <: PoloniexData
    amount::Maybe{Float64}
    ask::Maybe{Float64}
    askQuantity::Maybe{Float64}
    bid::Maybe{Float64}
    bidQuantity::Maybe{Float64}
    close::Maybe{Float64}
    closeTime::Maybe{NanoDate}
    dailyChange::Maybe{Float64}
    displayName::Maybe{String}
    high::Maybe{Float64}
    low::Maybe{Float64}
    markPrice::Maybe{Float64}
    open::Maybe{Float64}
    quantity::Maybe{Float64}
    startTime::Maybe{NanoDate}
    symbol::String
    tradeCount::Maybe{Int64}
    ts::NanoDate
end

function Serde.isempty(::Type{TickerData}, x)::Bool
    return x === ""
end

"""
    ticker(client::PoloniexClient, query::TickerQuery)
    ticker(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Retrieve ticker in last 24 hours for all symbols.

[`GET markets/{symbol}/ticker24h`](https://api-docs.poloniex.com/spot/api/public/market-data#ticker)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Poloniex

result = Poloniex.Spot.ticker(;
    symbol = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "amount":7.911171301524143e7,
  "ask":65322.3,
  "askQuantity":0.047754,
  "bid":65265.21,
  "bidQuantity":0.000457,
  "close":65294.16,
  "closeTime":"2024-05-16T17:09:07.225999872",
  "dailyChange":0.0062,
  "displayName":"BTC/USDT",
  "high":66664.38,
  "low":64757.87,
  "markPrice":65327.98,
  "open":64894.14,
  "quantity":1200.477812,
  "startTime":"2024-05-15T17:09:00",
  "symbol":"BTC_USDT",
  "tradeCount":61923,
  "ts":"2024-05-16T17:09:14.984"
}
```
"""
function ticker(client::PoloniexClient, query::TickerQuery; kw...)
    return if isnothing(query.symbol)
        APIsRequest{Vector{TickerData}}("GET", "markets/ticker24h", query)(client)
    else
        APIsRequest{TickerData}("GET", "markets/$(query.symbol)/ticker24h", query)(client)
    end
end

function ticker(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
