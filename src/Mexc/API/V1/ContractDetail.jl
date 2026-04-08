module ContractDetail

export ContractDetailQuery,
    ContractDetailData,
    contract_detail

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ContractDetailQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
end

struct ContractDetailData <: MexcData
    symbol::Maybe{String}
    displayName::Maybe{String}
    displayNameEn::Maybe{String}
    positionOpenType::Maybe{Int64}
    baseCoin::Maybe{String}
    quoteCoin::Maybe{String}
    settleCoin::Maybe{String}
    contractSize::Maybe{Float64}
    minLeverage::Maybe{Int64}
    maxLeverage::Maybe{Int64}
    priceScale::Maybe{Int64}
    volScale::Maybe{Int64}
    amountScale::Maybe{Int64}
    priceUnit::Maybe{Float64}
    volUnit::Maybe{Int64}
    minVol::Maybe{Float64}
    maxVol::Maybe{Float64}
    bidLimitPriceRate::Maybe{Float64}
    askLimitPriceRate::Maybe{Float64}
    takerFeeRate::Maybe{Float64}
    makerFeeRate::Maybe{Float64}
    maintenanceMarginRate::Maybe{Float64}
    initialMarginRate::Maybe{Float64}
    riskBaseVol::Maybe{Float64}
    riskIncrVol::Maybe{Float64}
    riskIncrMmr::Maybe{Float64}
    riskIncrImr::Maybe{Float64}
    riskLevelLimit::Maybe{Int64}
    priceCoefficientVariation::Maybe{Float64}
    indexOrigin::Maybe{Vector{String}}
    state::Maybe{Int64}
    isNew::Maybe{Bool}
    isHot::Maybe{Bool}
    isHidden::Maybe{Bool}
    conceptPlate::Maybe{Vector{String}}
    riskLimitType::Maybe{String}
    maxNumOrders::Maybe{Vector{Int64}}
    marketOrderMaxLevel::Maybe{Int64}
    marketOrderPriceLimitRate1::Maybe{Float64}
    marketOrderPriceLimitRate2::Maybe{Float64}
    triggerProtect::Maybe{Float64}
    appraisal::Maybe{Int64}
    showAppraisalCountdown::Maybe{Int64}
    automaticDelivery::Maybe{Int64}
    apiAllowed::Maybe{Bool}
end

"""
    contract_detail(client::MexcClient, query::ContractDetailQuery)
    contract_detail(client::MexcClient = MexcFuturesClient(Mexc.public_futures_config); kw...)

Get the contract information. Returns details of all futures contracts, or a specific one if symbol is provided.

[`GET api/v1/contract/detail`](https://mexcdevelop.github.io/apidocs/contract_v1_en/#get-the-contract-information)

## Parameters:

| Parameter | Type   | Required | Description                         |
|:----------|:-------|:---------|:------------------------------------|
| symbol    | String | false    | Contract name, e.g. BTC_USDT        |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V1.contract_detail()

to_pretty_json(result.result)
```

## Result:

```json
{
  "success":true,
  "code":0,
  "data":[
    {
      "symbol":"BTC_USDT",
      "displayNameEn":"BTC_USDT SWAP",
      "positionOpenType":3,
      "baseCoin":"BTC",
      "quoteCoin":"USDT",
      "settleCoin":"USDT",
      "contractSize":0.0001,
      "minLeverage":1,
      "maxLeverage":125,
      "priceScale":2,
      "volScale":0,
      "amountScale":4,
      "takerFeeRate":0.0006,
      "makerFeeRate":0.0002,
      "state":0,
      "apiAllowed":true,
      ...
    },
    ...
  ]
}
```
"""
function contract_detail(client::MexcClient, query::ContractDetailQuery)
    return if isnothing(query.symbol)
        APIsRequest{FuturesData{Vector{ContractDetailData}}}("GET", "api/v1/contract/detail", query)(client)
    else
        APIsRequest{FuturesData{ContractDetailData}}("GET", "api/v1/contract/detail", query)(client)
    end
end

function contract_detail(client::MexcClient = MexcFuturesClient(Mexc.public_futures_config); kw...)
    return contract_detail(client, ContractDetailQuery(; kw...))
end

end
