module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolsQuery <: KucoinPublicQuery
    #__ empty
end

struct SymbolsData <: KucoinData
    symbol::String
    baseCurrency::String
    quoteCurrency::String
    feeCurrency::String
    market::String
    baseMaxSize::Maybe{Float64}
    baseIncrement::Maybe{Float64}
    quoteMinSize::Maybe{Float64}
    quoteIncrement::Maybe{Float64}
    priceIncrement::Maybe{Float64}
    priceLimitRate::Maybe{Float64}
    minFunds::Maybe{Float64}
    isMarginEnabled::Maybe{Bool}
    enableTrading::Maybe{Bool}
    baseMinSize::Maybe{Float64}
    name::String
    quoteMaxSize::Maybe{Float64}
end

"""
    symbols(client::KucoinClient, query::SymbolsQuery)
    symbols(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/{symbol}`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbols-list)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.symbols()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"AVA-USDT",
    "baseCurrency":"AVA",
    "quoteCurrency":"USDT",
    "feeCurrency":"USDT",
    "market":"USDS",
    "baseMaxSize":1.0e10,
    "baseIncrement":0.01,
    "quoteMinSize":0.1,
    "quoteIncrement":0.0001,
    "priceIncrement":0.0001,
    "priceLimitRate":0.1,
    "minFunds":0.1,
    "isMarginEnabled":false,
    "enableTrading":true,
    "baseMinSize":0.1,
    "name":"AVA-USDT",
    "quoteMaxSize":9.9999999e7
  },
  ...
]
```
"""
function symbols(client::KucoinClient, query::SymbolsQuery)
    end_point = "/api/v2/symbols/"
    return APIsRequest{Data{Vector{SymbolsData}}}("GET", end_point, query)(client)
end

function symbols(client::KucoinClient = Kucoin.public_client; kw...)
    return symbols(client, SymbolsQuery(; kw...))
end

end
