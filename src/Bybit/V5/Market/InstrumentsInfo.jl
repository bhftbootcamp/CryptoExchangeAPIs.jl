module InstrumentsInfo

export InstrumentsInfoQuery,
    instruments_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category SPOT LINEAR INVERSE OPTION

@enumx ContractType LinearPerpetual LinearFutures InversePerpetual InverseFutures

@enumx OptionsType Call Put

Base.@kwdef struct InstrumentsInfoQuery <: BybitPublicQuery
    category::Category.T
    symbol::Maybe{String} = nothing
    status::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    limit::Maybe{Int} = nothing
    cursor::Maybe{String} = nothing
end

function Serde.ser_type(::Type{InstrumentsInfoQuery}, x::Category.T)
    x == Category.SPOT    && return "spot"
    x == Category.LINEAR  && return "linear"
    x == Category.INVERSE && return "inverse"
    x == Category.OPTION  && return "option"
end

struct LeverageFilter <: BybitData
    minLeverage::Float64
    maxLeverage::Float64
    leverageStep::Float64
end

struct LotSizeFilter <: BybitData
    minOrderQty::Float64
    maxOrderQty::Float64
    qtyStep::Maybe{Float64}
    minNotionalValue::Maybe{Float64}
    maxMktOrderQty::Maybe{Float64}
    postOnlyMaxOrderQty::Maybe{Float64}
    basePrecision::Maybe{Float64}
    quotePrecision::Maybe{Float64}
    minOrderAmt::Maybe{Float64}
    maxOrderAmt::Maybe{Float64}
    maxLimitOrderQty::Maybe{Float64}
    maxMarketOrderQty::Maybe{Float64}
    postOnlyMaxLimitOrderSize::Maybe{Float64}
end

struct PriceFilter <: BybitData
    minPrice::Maybe{Float64}
    maxPrice::Maybe{Float64}
    tickSize::Float64
end

struct RiskParameters <: BybitData
    priceLimitRatioX::Float64
    priceLimitRatioY::Float64
end

struct PreListingPhase <: BybitData
    phase::String
    startTime::String
    endTime::String
end

struct AuctionFeeInfo <: BybitData
    auctionFeeRate::Float64
    takerFeeRate::Float64
    makerFeeRate::Float64
end

struct PreListingInfo <: BybitData
    curAuctionPhase::String
    phases::Vector{PreListingPhase}
    auctionFeeInfo::AuctionFeeInfo
    skipCallAuction::Bool
end

struct SpotInstrumentData <: BybitData
    symbol::String
    baseCoin::String
    quoteCoin::String
    status::String
    marginTrading::String
    stTag::String
    lotSizeFilter::LotSizeFilter
    priceFilter::PriceFilter
    riskParameters::RiskParameters
end

struct FuturesInstrumentData <: BybitData
    symbol::String
    contractType::ContractType.T
    status::String
    baseCoin::String
    quoteCoin::String
    launchTime::NanoDate
    deliveryTime::NanoDate
    deliveryFeeRate::Maybe{Float64}
    priceScale::Int
    leverageFilter::LeverageFilter
    priceFilter::PriceFilter
    lotSizeFilter::LotSizeFilter
    unifiedMarginTrade::Bool
    fundingInterval::Int
    settleCoin::String
    copyTrading::String
    upperFundingRate::Float64
    lowerFundingRate::Float64
    displayName::Maybe{String}
    forbidUplWithdrawal::Bool
    riskParameters::RiskParameters
    isPreListing::Bool
    preListingInfo::Maybe{PreListingInfo}
end

struct OptionInstrumentData <: BybitData
    symbol::String
    optionsType::OptionsType.T
    status::String
    baseCoin::String
    quoteCoin::String
    settleCoin::String
    launchTime::NanoDate
    deliveryTime::NanoDate
    deliveryFeeRate::Float64
    priceFilter::PriceFilter
    lotSizeFilter::LotSizeFilter
    displayName::Maybe{String}
end

"""
    instruments_info(client::BybitClient, query::InstrumentsInfoQuery)
    instruments_info(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

Query for the instrument specification of online trading pairs.

[`GET /v5/market/instruments-info`](https://bybit-exchange.github.io/docs/v5/market/instrument)

## Parameters:

| Parameter  | Type    | Required | Description                                      |
|:-----------|:--------|:---------|:-------------------------------------------------|
| category   | Category| true     | SPOT LINEAR INVERSE OPTION                       |
| symbol     | String  | false    | Symbol name (e.g. BTCUSDT).                      |
| status     | String  | false    | Symbol status filter.                            |
| baseCoin   | String  | false    | Base coin (LINEAR/INVERSE/OPTION only).          |
| limit      | Int     | false    | Limit per page [1, 1000]. Default 500.           |
| cursor     | String  | false    | Pagination cursor.                               |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.instruments_info(;
    category = Bybit.V5.Market.InstrumentsInfo.Category.SPOT,
    symbol = "BTCUSDT",
)
```
"""
function instruments_info(client::BybitClient, query::InstrumentsInfoQuery)
    data_type = if query.category == Category.SPOT SpotInstrumentData
        elseif query.category == Category.OPTION OptionInstrumentData
        else FuturesInstrumentData
    end
    return APIsRequest{Data{List{data_type}}}("GET", "v5/market/instruments-info", query)(client)
end

function instruments_info(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return instruments_info(client, InstrumentsInfoQuery(; kw...))
end

end
