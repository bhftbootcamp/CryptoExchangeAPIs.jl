module ExchangeInfo

export ExchangeInfoQuery,
    ExchangeInfoData,
    exchange_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx SymbolStatus begin
    ONLINE = 1
    PAUSE = 2
    OFFLINE = 3
end

@enumx OrderType begin
    LIMIT
    MARKET
    LIMIT_MAKER
    IMMEDIATE_OR_CANCEL
    FILL_OR_KILL
end

@enumx TradeSide begin
    ALL = 1
    BUY = 2
    SELL = 3
    CLOSE = 4
end

Base.@kwdef struct ExchangeInfoQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
    symbols::Maybe{Vector{String}} = nothing
end

function Serde.SerQuery.ser_value(
    ::Type{ExchangeInfoQuery},
    ::Val{:symbols},
    x::Vector{String},
)
    return join(x, ",")
end

struct Filter <: MexcData
    filterType::String
    bidMultiplierUp::Float64
    askMultiplierDown::Float64
end

struct Symbol <: MexcData
    symbol::String
    status::SymbolStatus.T
    baseAsset::String
    baseAssetPrecision::Int
    quoteAsset::String
    quotePrecision::Int
    quoteAssetPrecision::Int
    baseCommissionPrecision::Int
    quoteCommissionPrecision::Int
    orderTypes::Vector{OrderType.T}
    isSpotTradingAllowed::Bool
    isMarginTradingAllowed::Bool
    quoteAmountPrecision::Float64
    baseSizePrecision::Float64
    permissions::Vector{String}
    filters::Vector{Filter}
    maxQuoteAmount::Float64
    makerCommission::Float64
    takerCommission::Float64
    quoteAmountPrecisionMarket::Float64
    maxQuoteAmountMarket::Float64
    fullName::String
    tradeSideType::TradeSide.T
    contractAddress::String
    st::Bool
end

function Serde.deser(::Type{Symbol}, ::Type{SymbolStatus.T}, x::String)
    return SymbolStatus.T(parse(Int, x))
end

function Serde.deser(::Type{Symbol}, ::Type{OrderType.T}, x::String)
    return OrderType.T(parse(Int, x))
end

function Serde.deser(::Type{Symbol}, ::Type{TradeSide.T}, x::String)
    return TradeSide.T(parse(Int, x))
end

struct ExchangeInfoData <: MexcData
    timezone::String
    serverTime::NanoDate
    symbols::Vector{Symbol}
end

"""
    exchange_info(client::MexcSpotClient, query::ExchangeInfoQuery)
    exchange_info(client::MexcSpotClient = Mexc.MexcSpotClient(Mexc.public_spot_config); kw...)

Current exchange trading rules and symbol information.

[`GET api/v3/exchangeInfo`](https://www.mexc.com/api-docs/spot-v3/market-data-endpoints#exchange-information)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| symbol      | String | false    |             |
| symbols     | Vector | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.exchange_info(; symbol = "ADAUSDT")
```
"""
function exchange_info(client::MexcSpotClient, query::ExchangeInfoQuery)
    return APIsRequest{ExchangeInfoData}("GET", "api/v3/exchangeInfo", query)(client)
end

function exchange_info(
    client::MexcSpotClient = MexcSpotClient(Mexc.public_spot_config);
    kw...,
)
    return exchange_info(client, ExchangeInfoQuery(; kw...))
end

end
