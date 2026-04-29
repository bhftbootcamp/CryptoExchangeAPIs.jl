module Detail

export DetailQuery,
    DetailData,
    detail

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx PositionOpenType begin
    ISOLATED = 1
    CROSS = 2
    BOTH = 3
end

@enumx ContractState begin
    ENABLED = 0
    DELIVERY = 1
    DELIVERED = 2
    OFFLINE = 3
    PAUSED = 4
end

@enumx RiskLimitType BY_VOLUME BY_VALUE

Base.@kwdef struct DetailQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
end

struct RiskLimitCustom <: MexcData
    level::Int
    maxVol::Int
    mmr::Float64
    imr::Float64
    maxLeverage::Int
end

struct DetailData <: MexcData
    symbol::String
    displayName::String
    displayNameEn::String
    positionOpenType::PositionOpenType.T
    baseCoin::String
    quoteCoin::String
    baseCoinName::String
    quoteCoinName::String
    futureType::Int
    settleCoin::String
    contractSize::Float64
    minLeverage::Int
    maxLeverage::Int
    priceScale::Int
    volScale::Int
    amountScale::Int
    priceUnit::Float64
    volUnit::Int
    minVol::Int
    maxVol::Int
    bidLimitPriceRate::Float64
    askLimitPriceRate::Float64
    takerFeeRate::Float64
    makerFeeRate::Float64
    maintenanceMarginRate::Float64
    initialMarginRate::Float64
    riskBaseVol::Int
    riskIncrVol::Int
    riskLongShortSwitch::Int
    riskIncrMmr::Float64
    riskIncrImr::Float64
    riskLevelLimit::Int
    priceCoefficientVariation::Float64
    indexOrigin::Vector{String}
    state::ContractState.T
    isNew::Bool
    isHot::Bool
    isHidden::Bool
    conceptPlate::Vector{String}
    conceptPlateId::Vector{Int}
    riskLimitType::RiskLimitType.T
    maxNumOrders::Vector{Int}
    marketOrderMaxLevel::Int
    marketOrderPriceLimitRate1::Float64
    marketOrderPriceLimitRate2::Float64
    triggerProtect::Float64
    appraisal::Int
    showAppraisalCountdown::Int
    automaticDelivery::Int
    apiAllowed::Bool
    depthStepList::Vector{String}
    limitMaxVol::Int
    threshold::Int
    baseCoinIconUrl::String
    id::Int
    vid::Maybe{String}
    baseCoinId::String
    createTime::NanoDate
    openingTime::Maybe{NanoDate}
    openingCountdownOption::Int
    showBeforeOpen::Bool
    isMaxLeverage::Bool
    isZeroFeeRate::Bool
    riskLimitMode::String
    isZeroFeeSymbol::Bool
    riskLimitCustom::Maybe{Vector{RiskLimitCustom}}
end

function Serde.deser(::Type{DetailData}, ::Type{PositionOpenType.T}, x::Int)
    return PositionOpenType.T(x)
end

function Serde.deser(::Type{DetailData}, ::Type{ContractState.T}, x::Int)
    return ContractState.T(x)
end

function Serde.deser(::Type{DetailData}, ::Type{NanoDate}, x::Int)
    return iszero(x) ? nothing : unixnanos2nanodate(x * 10^6)
end

"""
    detail(client::MexcFuturesClient, query::DetailQuery)
    detail(client::MexcFuturesClient = Mexc.MexcFuturesClient(Mexc.public_futures_config); kw...)

Get Contract Info.

[`GET api/v1/contract/detail`](https://www.mexc.com/api-docs/futures/market-endpoints#get-contract-info)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| symbol      | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V1.Contract.detail(; symbol = "ADA_USDT")
```
"""
function detail(client::MexcFuturesClient, query::DetailQuery)
    datatype = isnothing(query.symbol) ? Vector{DetailData} : DetailData
    return APIsRequest{Mexc.FuturesData{datatype}}("GET", "api/v1/contract/detail", query)(client)
end

function detail(
    client::MexcFuturesClient = MexcFuturesClient(Mexc.public_futures_config);
    kw...,
)
    return detail(client, DetailQuery(; kw...))
end

end
