module Active

export ActiveQuery,
    ActiveData,
    active

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx ContractStatus begin
    Init
    Open
    BeingSettled
    Settled
    Paused
    Closed
    CancelOnly
end

@enumx ContractType FFWCSX FFICSX

Base.@kwdef struct ActiveQuery <: KucoinPublicQuery
    #__ empty
end

struct ActiveData <: KucoinData
    symbol::String
    rootSymbol::String
    type::ContractType.T
    firstOpenDate::NanoDate
    expireDate::Maybe{NanoDate}
    settleDate::Maybe{NanoDate}
    baseCurrency::String
    quoteCurrency::String
    settleCurrency::String
    maxOrderQty::Maybe{Int}
    maxPrice::Maybe{Float64}
    lotSize::Maybe{Int}
    tickSize::Maybe{Float64}
    indexPriceTickSize::Maybe{Float64}
    multiplier::Maybe{Float64}
    initialMargin::Maybe{Float64}
    maintainMargin::Maybe{Float64}
    maxRiskLimit::Maybe{Int}
    minRiskLimit::Maybe{Int}
    riskStep::Maybe{Int}
    makerFeeRate::Maybe{Float64}
    takerFeeRate::Maybe{Float64}
    takerFixFee::Maybe{Float64}
    makerFixFee::Maybe{Float64}
    settlementFee::Maybe{Float64}
    isDeleverage::Bool
    isQuanto::Bool
    isInverse::Bool
    markMethod::Maybe{String}
    fairMethod::Maybe{String}
    fundingBaseSymbol::Maybe{String}
    fundingQuoteSymbol::Maybe{String}
    fundingRateSymbol::Maybe{String}
    indexSymbol::Maybe{String}
    settlementSymbol::Maybe{String}
    status::ContractStatus.T
    fundingFeeRate::Maybe{Float64}
    predictedFundingFeeRate::Maybe{Float64}
    openInterest::Maybe{String}
    turnoverOf24h::Maybe{Float64}
    volumeOf24h::Maybe{Float64}
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    lastTradePrice::Maybe{Float64}
    nextFundingRateTime::Maybe{Int}
    maxLeverage::Maybe{Int}
    sourceExchanges::Maybe{Vector}
    premiumsSymbol1M::Maybe{String}
    premiumsSymbol8H::Maybe{String}
    fundingBaseSymbol1M::Maybe{String}
    fundingQuoteSymbol1M::Maybe{String}
    lowPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    priceChgPct::Maybe{Float64}
    priceChg::Maybe{Float64}
    fundingRateGranularity::Maybe{Int}
end

"""
    active(client::KucoinClient, query::ActiveQuery)
    active(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_futures_config); kw...)

Submit request to get the info of all open contracts.

[`GET api/v1/contracts/active`](https://www.kucoin.com/docs/rest/futures-trading/market-data/get-symbols-list)

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin.API.V1.Contracts.active()
```
"""
function active(client::KucoinClient, query::ActiveQuery)
    return APIsRequest{Data{Vector{ActiveData}}}("GET", "api/v1/contracts/active", query)(client)
end

function active(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_futures_config); kw...)
    return active(client, ActiveQuery(; kw...))
end

end

