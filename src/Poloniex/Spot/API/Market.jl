module Market

export MarketQuery,
    MarketData,
    market

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Poloniex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketQuery <: PoloniexPublicQuery
    symbol::Maybe{String} = nothing
end

function Serde.ser_ignore_field(::Type{<:MarketQuery}, ::Val{:symbol})::Bool
    return true
end

struct SymbolTradeLimit <: PoloniexData
    amountScale::Int64
    highestBid::Float64
    lowestAsk::Float64
    minAmount::Float64
    minQuantity::Float64
    priceScale::Int64
    quantityScale::Int64
    symbol::String
end

struct CrossMargin <: PoloniexData
    maxLeverage::Int64
    supportCrossMargin::Bool
end

struct MarketData <: PoloniexData
    baseCurrencyName::String
    crossMargin::CrossMargin
    displayName::String
    quoteCurrencyName::String
    state::String
    symbol::String
    symbolTradeLimit::SymbolTradeLimit
    tradableStartTime::NanoDate
    visibleStartTime::NanoDate
end

"""
    market(client::PoloniexClient, query::MarketQuery)
    market(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get all symbols and their tradeLimit info.

[`GET markets/{symbol}`](https://api-docs.poloniex.com/spot/api/public/reference-data#symbol-information)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Poloniex

result = Poloniex.Spot.market(;
    symbol = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "baseCurrencyName":"BTC",
    "crossMargin":{
      "maxLeverage":3,
      "supportCrossMargin":true
    },
    "displayName":"BTC/USDT",
    "quoteCurrencyName":"USDT",
    "state":"NORMAL",
    "symbol":"BTC_USDT",
    "symbolTradeLimit":{
      "amountScale":2,
      "highestBid":0.0,
      "lowestAsk":0.0,
      "minAmount":1.0,
      "minQuantity":1.0e-6,
      "priceScale":2,
      "quantityScale":6,
      "symbol":"BTC_USDT"
    },
    "tradableStartTime":"2022-07-28T14:33:39.512",
    "visibleStartTime":"2022-07-28T14:33:39.512"
  }
]
```
"""
function market(client::PoloniexClient, query::MarketQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets" : "markets/$(query.symbol)"
    return APIsRequest{Vector{MarketData}}("GET", endpoint, query)(client)
end

function market(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return market(client, MarketQuery(; kw...))
end

end
