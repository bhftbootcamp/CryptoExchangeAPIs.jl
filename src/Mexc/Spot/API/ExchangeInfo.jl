module ExchangeInfo

export ExchangeInfoQuery,
    ExchangeInfoData,
    exchange_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ExchangeInfoQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
    symbols::Maybe{String} = nothing
end

struct Symbols <: MexcData
    symbol::String
    status::Maybe{String}
    baseAsset::Maybe{String}
    baseAssetPrecision::Maybe{Int64}
    quoteAsset::Maybe{String}
    quotePrecision::Maybe{Int64}
    quoteAssetPrecision::Maybe{Int64}
    baseCommissionPrecision::Maybe{Int64}
    quoteCommissionPrecision::Maybe{Int64}
    orderTypes::Maybe{Vector{String}}
    quoteOrderQtyMarketAllowed::Maybe{Bool}
    isSpotTradingAllowed::Maybe{Bool}
    isMarginTradingAllowed::Maybe{Bool}
    permissions::Maybe{Vector{String}}
    maxQuoteAmount::Maybe{String}
    makerCommission::Maybe{String}
    takerCommission::Maybe{String}
    quoteAmountPrecision::Maybe{String}
    baseSizePrecision::Maybe{String}
    quoteAmountPrecisionMarket::Maybe{String}
    maxQuoteAmountMarket::Maybe{String}
    tradeSideType::Maybe{String}
    filters::Maybe{Vector{Any}}
end

struct ExchangeInfoData <: MexcData
    timezone::Maybe{String}
    serverTime::Maybe{NanoDate}
    rateLimits::Maybe{Vector{Any}}
    exchangeFilters::Maybe{Vector{Any}}
    symbols::Vector{Symbols}
end

"""
    exchange_info(client::MexcClient, query::ExchangeInfoQuery)
    exchange_info(client::MexcClient = Mexc.Spot.public_client; kw...)

Current exchange trading rules and symbol information.

[`GET api/v3/exchangeInfo`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#exchange-information)

## Parameters:

| Parameter | Type   | Required | Description                                            |
|:----------|:-------|:---------|:-------------------------------------------------------|
| symbol    | String | false    | Single symbol, e.g. "MXUSDT"                          |
| symbols   | String | false    | Comma-separated symbols, e.g. "MXUSDT,BTCUSDT"        |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.Spot.exchange_info(;
    symbol = "BTCUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "timezone":"UTC",
  "serverTime":"2024-04-01T09:35:01.003000064",
  "rateLimits":[],
  "exchangeFilters":[],
  "symbols":[
    {
      "symbol":"BTCUSDT",
      "status":"ENABLED",
      "baseAsset":"BTC",
      "baseAssetPrecision":6,
      ...
    }
  ]
}
```
"""
function exchange_info(client::MexcClient, query::ExchangeInfoQuery)
    return APIsRequest{ExchangeInfoData}("GET", "api/v3/exchangeInfo", query)(client)
end

function exchange_info(client::MexcClient = Mexc.Spot.public_client; kw...)
    return exchange_info(client, ExchangeInfoQuery(; kw...))
end

end
