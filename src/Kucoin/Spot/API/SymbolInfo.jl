module SymbolInfo

export SymbolInfoQuery,
    SymbolInfoData,
    symbol_info,
    symbols_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolInfoQuery <: KucoinPublicQuery
    symbol::String
end

Base.@kwdef struct SymbolsInfoQuery <: KucoinPublicQuery
    #__ empty
end

struct SymbolInfoData <: KucoinData
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
    symbol_info(client::KucoinClient, query::SymbolInfoQuery)
    symbol_info(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/{symbol}`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbol-detail)

| Parameter  | Type       | Required | Description |
|:-----------|:-----------|:---------|:------------|
| symbol     | String     | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.symbol_info(; 
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
function symbol_info(client::KucoinClient, query::SymbolInfoQuery)
    end_point = "/api/v2/symbols/$(query.symbol)"
    return APIsRequest{Data{SymbolInfoData}}("GET", end_point, query)(client)
end

function symbol_info(client::KucoinClient = Kucoin.Spot.public_client; kw...)
    return symbol_info(client, SymbolInfoQuery(; kw...))
end

"""
    symbols_info(client::KucoinClient, query::SymbolsInfoQuery)
    symbols_info(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get detail currency pairs for trading.

[`GET /api/v2/symbols/{symbol}`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-symbols-list)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.symbols_info()

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
function symbols_info(client::KucoinClient, query::SymbolsInfoQuery)
    end_point = "/api/v2/symbols/"
    return APIsRequest{Data{Vector{SymbolInfoData}}}("GET", end_point, query)(client)
end

function symbols_info(client::KucoinClient = Kucoin.Spot.public_client; kw...)
    return symbols_info(client, SymbolsInfoQuery(; kw...))
end

end
