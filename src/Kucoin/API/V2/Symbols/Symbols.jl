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
    tradingStartTime::Maybe{Int64}
end

"""
    symbols(client::KucoinClient, query::SymbolsQuery)
    symbols(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbols-list)

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V2.Symbols.symbols()
```
"""
function symbols(client::KucoinClient, query::SymbolsQuery)
    return APIsRequest{Data{Vector{SymbolsData}}}("GET", "api/v2/symbols", query)(client)
end

function symbols(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)
    return symbols(client, SymbolsQuery(; kw...))
end

include("Symbol.jl")
using .Symbol

end
