module Symbol

export SymbolQuery,
    SymbolData,
    symbol

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolQuery <: KucoinPublicQuery
    symbol::String
end

struct SymbolData <: KucoinData
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
    symbol(client::KucoinClient, query::SymbolQuery)
    symbol(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/{symbol}`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbol-detail)

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V2.Symbols.symbol(;
    symbol = "BTC-USDT"
)
```
"""
function symbol(client::KucoinClient, query::SymbolQuery)
    end_point = "api/v2/symbols/$(query.symbol)"
    return APIsRequest{Data{SymbolData}}("GET", end_point, query)(client)
end

function symbol(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_config); kw...)
    return symbol(client, SymbolQuery(; kw...))
end

end

