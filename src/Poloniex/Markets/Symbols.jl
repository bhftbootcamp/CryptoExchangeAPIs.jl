module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using Serde
using EnumX
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx State NORMAL PAUSE POST_ONLY

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
    state::State.T
    visibleStartTime::NanoDate
    tradableStartTime::NanoDate
    symbolTradeLimit::SymbolTradeLimit
    crossMargin::CrossMargin
end

"""
    symbols(client::PoloniexClient, query::SymbolsQuery)
    symbols(client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config); kw...)

Get all symbols and their tradeLimit info.

[`GET markets/{symbol}`](https://api-docs.poloniex.com/spot/api/public/reference-data#symbol-information)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Markets.symbols(;
    symbol = "BTC_USDT",
)
```
"""
function symbols(client::PoloniexClient, query::SymbolsQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets" : "markets/$(query.symbol)"
    return APIsRequest{Vector{SymbolsData}}("GET", endpoint, query)(client)
end

function symbols(
    client::PoloniexClient = Poloniex.PoloniexClient(Poloniex.public_config);
    kw...,
)
    return symbols(client, SymbolsQuery(; kw...))
end

end
