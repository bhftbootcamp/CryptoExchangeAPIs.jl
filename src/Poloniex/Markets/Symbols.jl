module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolsQuery <: PoloniexPublicQuery
    symbol::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{SymbolsQuery}, ::Val{:symbol}) = true

struct SymbolTradeLimit <: PoloniexData
    symbol::String
    amountScale::Int64
    highestBid::Float64
    lowestAsk::Float64
    minAmount::Float64
    minQuantity::Float64
    priceScale::Int64
    quantityScale::Int64
end

struct CrossMargin <: PoloniexData
    maxLeverage::Int64
    supportCrossMargin::Bool
end

struct SymbolsData <: PoloniexData
    symbol::String
    baseCurrencyName::String
    quoteCurrencyName::String
    displayName::String
    state::String
    visibleStartTime::NanoDate
    tradableStartTime::NanoDate
    symbolTradeLimit::SymbolTradeLimit
    crossMargin::CrossMargin
end

"""
    symbols(client::PoloniexClient, query::SymbolsQuery)
    symbols(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get all symbols and their tradeLimit info.

[`GET markets/{symbol}`](https://api-docs.poloniex.com/spot/api/public/reference-data#symbol-information)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Spot.market(;
    symbol = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTC_USDT",
    "baseCurrencyName":"BTC",
    "quoteCurrencyName":"USDT",
    "displayName":"BTC/USDT",
    "state":"NORMAL",
    "visibleStartTime":"2022-07-28T14:33:39.512",
    "tradableStartTime":"2022-07-28T14:33:39.512",
    "symbolTradeLimit":{
      "symbol":"BTC_USDT",
      "amountScale":2,
      "highestBid":0.0,
      "lowestAsk":0.0,
      "minAmount":1.0,
      "minQuantity":1.0e-6,
      "priceScale":2,
      "quantityScale":6
    },
        "crossMargin":{
      "maxLeverage":3,
      "supportCrossMargin":true
    }
  }
]
```
"""
function symbols(client::PoloniexClient, query::SymbolsQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets" : "markets/$(query.symbol)"
    return APIsRequest{Vector{SymbolsData}}("GET", endpoint, query)(client)
end

function symbols(client::PoloniexClient = Poloniex.public_client; kw...)
    return symbols(client, SymbolsQuery(; kw...))
end

end
