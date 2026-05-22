module ExchangeInfo

export ExchangeInfoQuery,
    ExchangeInfoData,
    exchange_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

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
    contractType::Maybe{String}
    deliveryDate::NanoDate
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
    settlePlan::Maybe{Int64}
    status::String
    symbol::String
    timeInForce::Vector{String}
    triggerProtect::Float64
    underlyingSubType::Vector{String}
    underlyingType::String
end

struct Asset <: BinanceData
    asset::String
    autoAssetExchange::Float64
    marginAvailable::Bool
end

struct ExchangeInfoData <: BinanceData
    assets::Vector{Asset}
    exchangeFilters::Nothing
    futuresType::String
    rateLimits::Vector{Ratelimit}
    serverTime::NanoDate
    symbols::Vector{Symbols}
    timezone::String
end

function Serde.isempty(::Type{Symbols}, x)::Bool
    return x === ""
end

function Serde.isempty(::Type{ExchangeInfoData}, x)::Bool
    return x == []
end

"""
    exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    exchange_info(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

Current exchange trading rules and symbol information.

[`GET fapi/v1/exchangeInfo`](https://binance-docs.github.io/apidocs/futures/en/#exchange-information)

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.exchange_info()
```
"""
function exchange_info(client::BinanceClient, query::ExchangeInfoQuery)
    return APIsRequest{ExchangeInfoData}("GET", "fapi/v1/exchangeInfo", query)(client)
end

function exchange_info(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return exchange_info(client, ExchangeInfoQuery(; kw...))
end

end
