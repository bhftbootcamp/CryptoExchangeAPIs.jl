module ExchangeInfo

export ExchangeInfoQuery,
    ExchangeInfoData,
    exchange_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum Permission SPOT MARGIN LEVERAGED TRD_GRP_002 TRD_GRP_003 TRD_GRP_004 TRD_GRP_005 TRD_GRP_006 TRD_GRP_007

Base.@kwdef struct ExchangeInfoQuery <: BinancePublicQuery
    permissions::Maybe{Vector{Permission}} = nothing
    symbol::Maybe{String} = nothing
    symbols::Maybe{Vector{String}} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:ExchangeInfoQuery}, x::Vector{String})::String
    return "[\"" * join(x, "\",\"") * "\"]"
end

function Serde.SerQuery.ser_type(::Type{<:ExchangeInfoQuery}, x::Vector{Permission})::String
    return "[\"" * join(x, "\",\"") * "\"]"
end

struct Filter <: BinanceData
    applyToMarket::Maybe{Bool}
    askMultiplierDown::Maybe{Float64}
    askMultiplierUp::Maybe{Float64}
    avgPriceMins::Maybe{Int64}
    bidMultiplierDown::Maybe{Float64}
    bidMultiplierUp::Maybe{Float64}
    filterType::String
    limit::Maybe{Int64}
    maxNumAlgoOrders::Maybe{Int64}
    maxNumOrders::Maybe{Int64}
    maxPosition::Maybe{Float64}
    maxPrice::Maybe{Float64}
    maxQty::Maybe{Float64}
    maxTrailingAboveDelta::Maybe{Int64}
    maxTrailingBelowDelta::Maybe{Int64}
    minNotional::Maybe{Float64}
    minPrice::Maybe{Float64}
    minQty::Maybe{Float64}
    minTrailingAboveDelta::Maybe{Int64}
    minTrailingBelowDelta::Maybe{Int64}
    multiplierDown::Maybe{Float64}
    multiplierUp::Maybe{Float64}
    stepSize::Maybe{Float64}
    tickSize::Maybe{Float64}
end

struct Ratelimit <: BinanceData
    limit::Int64
    rateLimitType::String
    interval::String
    intervalNum::Int64
end

struct Symbols <: BinanceData
    allowTrailingStop::Bool
    allowedSelfTradePreventionModes::Vector{String}
    baseAsset::String
    baseAssetPrecision::Int64
    baseCommissionPrecision::Int64
    cancelReplaceAllowed::Bool
    defaultSelfTradePreventionMode::String
    filters::Vector{Filter}
    icebergAllowed::Bool
    isMarginTradingAllowed::Bool
    isSpotTradingAllowed::Bool
    ocoAllowed::Bool
    orderTypes::Vector{String}
    permissions::Vector{Any}
    quoteAsset::String
    quoteAssetPrecision::Int64
    quoteCommissionPrecision::Int64
    quoteOrderQtyMarketAllowed::Bool
    quotePrecision::Int64
    status::String
    symbol::String
end

struct ExchangeInfoData <: BinanceData
    exchangeFilters::Vector{Any}
    rateLimits::Vector{Ratelimit}
    serverTime::NanoDate
    symbols::Vector{Symbols}
    timezone::String
end

"""
    exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    exchange_info(client::BinanceClient = Binance.Spot.public_client; kw...)

Current exchange trading rules and symbol information.

[`GET api/v3/exchangeInfo`](https://binance-docs.github.io/apidocs/spot/en/#exchange-information)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| permissions | Vector | false    |             |
| symbol      | String | false    |             |
| symbols     | Vector | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.Spot.exchange_info(;
    symbol = "ADAUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "exchangeFilters":[],
  "rateLimits":[
    {
      "limit":6000,
      "rateLimitType":"REQUEST_WEIGHT",
      "interval":"MINUTE",
      "intervalNum":1
    },
    ...
  ],
  "serverTime":"2024-04-01T09:35:01.003000064",
  "symbols":[
    {
      "allowTrailingStop":true,
      "allowedSelfTradePreventionModes":[
        "EXPIRE_TAKER",
        "EXPIRE_MAKER",
        "EXPIRE_BOTH"
      ],
      "baseAsset":"ADA",
      "baseAssetPrecision":8,
      "baseCommissionPrecision":8,
      "cancelReplaceAllowed":true,
      "defaultSelfTradePreventionMode":"EXPIRE_MAKER",
      "filters":[
        {
          "applyToMarket":null,
          "askMultiplierDown":null,
          "askMultiplierUp":null,
          "avgPriceMins":null,
          "bidMultiplierDown":null,
          "bidMultiplierUp":null,
          "filterType":"PRICE_FILTER",
          "limit":null,
          "maxNumAlgoOrders":null,
          "maxNumOrders":null,
          "maxPosition":null,
          "maxPrice":1000.0,
          "maxQty":null,
          "maxTrailingAboveDelta":null,
          "maxTrailingBelowDelta":null,
          "minNotional":null,
          "minPrice":0.0001,
          "minQty":null,
          "minTrailingAboveDelta":null,
          "minTrailingBelowDelta":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "stepSize":null,
          "tickSize":0.0001
        },
        ...
      ],
      "icebergAllowed":true,
      "isMarginTradingAllowed":true,
      "isSpotTradingAllowed":true,
      "ocoAllowed":true,
      "orderTypes":[
        "LIMIT",
        "LIMIT_MAKER",
        "MARKET",
        "STOP_LOSS_LIMIT",
        "TAKE_PROFIT_LIMIT"
      ],
      "permissions":[
        "SPOT",
        "MARGIN",
        "TRD_GRP_004",
        ...
      ],
      "quoteAsset":"USDT",
      "quoteAssetPrecision":8,
      "quoteCommissionPrecision":8,
      "quoteOrderQtyMarketAllowed":true,
      "quotePrecision":8,
      "status":"TRADING",
      "symbol":"ADAUSDT"
    }
  ],
  "timezone":"UTC"
}
```
"""
function exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    return APIsRequest{ExchangeInfoData}("GET", "api/v3/exchangeInfo", query)(client)
end

function exchange_info(client::BinanceClient = Binance.Spot.public_client; kw...)
    return exchange_info(client, ExchangeInfoQuery(; kw...))
end

end
