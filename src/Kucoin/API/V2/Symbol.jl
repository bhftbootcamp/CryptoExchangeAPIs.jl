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
end

"""
    symbol(client::KucoinClient, query::SymbolQuery)
    symbol(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/{symbol}`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbol-detail)

| Parameter  | Type       | Required | Description |
|:-----------|:-----------|:---------|:------------|
| symbol     | String     | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.symbol(; 
    symbol = "BTC-USDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "symbol":"BTC-USDT",
  "baseCurrency":"BTC",
  "quoteCurrency":"USDT",
  "feeCurrency":"USDT",
  "market":"USDS",
  "baseMaxSize":1.0e10,
  "baseIncrement":1.0e-8,
  "quoteMinSize":0.1,
  "quoteIncrement":1.0e-6,
  "priceIncrement":0.1,
  "priceLimitRate":0.1,
  "minFunds":0.1,
  "isMarginEnabled":true,
  "enableTrading":true,
  "baseMinSize":1.0e-5,
  "name":"BTC-USDT",
  "quoteMaxSize":9.9999999e7
}
```
"""
function symbol(client::KucoinClient, query::SymbolQuery)
    end_point = "/api/v2/symbols/$(query.symbol)"
    return APIsRequest{Data{SymbolData}}("GET", end_point, query)(client)
end

function symbol(client::KucoinClient = Kucoin.public_client; kw...)
    return symbol(client, SymbolQuery(; kw...))
end

end
