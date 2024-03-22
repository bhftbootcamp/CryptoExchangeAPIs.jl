module ExchangeInfo

export ExchangeInfoQuery,
    ExchangeInfoData,
    exchange_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct ExchangeInfoQuery <: BinancePublicQuery
    #__ empty
end

struct Filter <: BinanceData
    filterType::String
    limit::Maybe{Int64}
    maxPrice::Maybe{Float64}
    maxQty::Maybe{Float64}
    minPrice::Maybe{Float64}
    minQty::Maybe{Float64}
    multiplierDecimal::Maybe{Float64}
    multiplierDown::Maybe{Float64}
    multiplierUp::Maybe{Float64}
    notional::Maybe{Float64}
    stepSize::Maybe{Float64}
    tickSize::Maybe{Float64}
end

struct Ratelimit <: BinanceData
    interval::String
    intervalNum::Int64
    limit::Int64
    rateLimitType::String
end

struct Symbols <: BinanceData
    baseAsset::String
    baseAssetPrecision::Int64
    contractSize::Int64
    contractStatus::String
    contractType::Maybe{String}
    deliveryDate::NanoDate
    equalQtyPrecision::Int64
    filters::Vector{Filter}
    liquidationFee::Float64
    maintMarginPercent::Float64
    marginAsset::String
    marketTakeBound::Float64
    maxMoveOrderLimit::Int64
    onboardDate::NanoDate
    orderTypes::Vector{String}
    pair::String
    pricePrecision::Int64
    quantityPrecision::Int64
    quoteAsset::String
    quotePrecision::Int64
    requiredMarginPercent::Float64
    symbol::String
    timeInForce::Vector{String}
    triggerProtect::Float64
    underlyingSubType::Vector{String}
    underlyingType::String
end

function Serde.isempty(::Type{Symbols}, x)::Bool
    return x === ""
end

struct ExchangeInfoData <: BinanceData
    exchangeFilters::Nothing
    rateLimits::Vector{Ratelimit}
    serverTime::NanoDate
    symbols::Vector{Symbols}
    timezone::String
end

function Serde.isempty(::Type{ExchangeInfoData}, x)::Bool
    return x == []
end

"""
    exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    exchange_info(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)

Current exchange trading rules and symbol information.

[`GET dapi/v1/exchangeInfo`](https://binance-docs.github.io/apidocs/delivery/en/#exchange-information)

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.CoinMFutures.exchange_info() 

to_pretty_json(result.result)
```

## Result:

```json
{
  "symbols":[
    {
      "baseAsset":"BTC",
      "baseAssetPrecision":8,
      "contractSize":100,
      "contractStatus":"TRADING",
      "contractType":"PERPETUAL",
      "deliveryDate":"2100-12-25T08:00:00",
      "equalQtyPrecision":4,
      "filters":[
        {
          "filterType":"PRICE_FILTER",
          "limit":null,
          "maxPrice":4.520958e6,
          "maxQty":null,
          "minPrice":1000.0,
          "minQty":null,
          "multiplierDecimal":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "notional":null,
          "stepSize":null,
          "tickSize":0.1
        },
        {
          "filterType":"LOT_SIZE",
          "limit":null,
          "maxPrice":null,
          "maxQty":1.0e6,
          "minPrice":null,
          "minQty":1.0,
          "multiplierDecimal":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "notional":null,
          "stepSize":1.0,
          "tickSize":null
        },
        {
          "filterType":"MARKET_LOT_SIZE",
          "limit":null,
          "maxPrice":null,
          "maxQty":60000.0,
          "minPrice":null,
          "minQty":1.0,
          "multiplierDecimal":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "notional":null,
          "stepSize":1.0,
          "tickSize":null
        },
        {
          "filterType":"MAX_NUM_ORDERS",
          "limit":200,
          "maxPrice":null,
          "maxQty":null,
          "minPrice":null,
          "minQty":null,
          "multiplierDecimal":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "notional":null,
          "stepSize":null,
          "tickSize":null
        },
        {
          "filterType":"MAX_NUM_ALGO_ORDERS",
          "limit":20,
          "maxPrice":null,
          "maxQty":null,
          "minPrice":null,
          "minQty":null,
          "multiplierDecimal":null,
          "multiplierDown":null,
          "multiplierUp":null,
          "notional":null,
          "stepSize":null,
          "tickSize":null
        },
        {
          "filterType":"PERCENT_PRICE",
          "limit":null,
          "maxPrice":null,
          "maxQty":null,
          "minPrice":null,
          "minQty":null,
          "multiplierDecimal":4.0,
          "multiplierDown":0.95,
          "multiplierUp":1.05,
          "notional":null,
          "stepSize":null,
          "tickSize":null
        }
      ],
      "liquidationFee":0.015,
      "maintMarginPercent":2.5,
      "marginAsset":"BTC",
      "marketTakeBound":0.05,
      "maxMoveOrderLimit":10000,
      "onboardDate":"2020-08-10T07:00:00",
      "orderTypes":[
        "LIMIT",
        "MARKET",
        "STOP",
        "STOP_MARKET",
        "TAKE_PROFIT",
        "TAKE_PROFIT_MARKET",
        "TRAILING_STOP_MARKET"
      ],
      "pair":"BTCUSD",
      "pricePrecision":1,
      "quantityPrecision":0,
      "quoteAsset":"USD",
      "quotePrecision":8,
      "requiredMarginPercent":5.0,
      "symbol":"BTCUSD_PERP",
      "timeInForce":[
        "GTC",
        "IOC",
        "FOK",
        "GTX"
      ],
      "triggerProtect":0.05,
      "underlyingSubType":[
        "PoW"
      ],
      "underlyingType":"COIN"
    },
    ...
  ],
  "serverTime":"2024-03-21T22:00:07.956",
  "exchangeFilters":null,
  "timezone":"UTC",
  "rateLimits":[
    {
      "interval":"MINUTE",
      "intervalNum":1,
      "limit":2400,
      "rateLimitType":"REQUEST_WEIGHT"
    },
    ...
  ]
}
```
"""
function exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    return APIsRequest{ExchangeInfoData}("GET", "dapi/v1/exchangeInfo", query)(client)
end

function exchange_info(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return exchange_info(client, ExchangeInfoQuery(; kw...))
end

end
