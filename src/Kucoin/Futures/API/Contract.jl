module Contract

export ContractQuery,
    ContractData,
    contract

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ContractQuery <: KucoinPublicQuery
    #__ empty
end

struct ContractData <: KucoinData
    symbol::String
    rootSymbol::String
    type::String
    firstOpenDate::NanoDate
    expireDate::Maybe{NanoDate}
    settleDate::Maybe{NanoDate}
    baseCurrency::String
    quoteCurrency::String
    settleCurrency::String
    maxOrderQty::Maybe{Int64}
    maxPrice::Maybe{Float64}
    lotSize::Maybe{Int64}
    tickSize::Maybe{Float64}
    indexPriceTickSize::Maybe{Float64}
    multiplier::Maybe{Float64}
    initialMargin::Maybe{Float64}
    maintainMargin::Maybe{Float64}
    maxRiskLimit::Maybe{Int64}
    minRiskLimit::Maybe{Int64}
    riskStep::Maybe{Int64}
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
    status::String
    fundingFeeRate::Maybe{Float64}
    predictedFundingFeeRate::Maybe{Float64}
    openInterest::Maybe{String}
    turnoverOf24h::Maybe{Float64}
    volumeOf24h::Maybe{Float64}
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    lastTradePrice::Maybe{Float64}
    nextFundingRateTime::Maybe{Int64}
    maxLeverage::Maybe{Int64}
    sourceExchanges::Maybe{Vector}
    premiumsSymbol1M::Maybe{String}
    premiumsSymbol8H::Maybe{String}
    fundingBaseSymbol1M::Maybe{String}
    fundingQuoteSymbol1M::Maybe{String}
    lowPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    priceChgPct::Maybe{Float64}
    priceChg::Maybe{Float64}
end

"""
    contract(client::KucoinClient, query::ContractQuery)
    contract(client::KucoinClient = Kucoin.Futures.public_client; kw...)

Submit request to get the info of all open contracts.

[`GET api/v1/contracts/active`](https://www.kucoin.com/docs/rest/futures-trading/market-data/get-symbols-list)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Futures.contract()

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200000,
  "data":[
    {
      "symbol":"XEMUSDTM",
      "rootSymbol":"USDT",
      "type":"FFWCSX",
      "firstOpenDate":"2021-04-09T08:00:00",
      "expireDate":null,
      "settleDate":null,
      "baseCurrency":"XEM",
      "quoteCurrency":"USDT",
      "settleCurrency":"USDT",
      "maxOrderQty":1000000,
      "maxPrice":1.0e6,
      "lotSize":1,
      "tickSize":1.0e-5,
      "indexPriceTickSize":1.0e-5,
      "multiplier":1.0,
      "initialMargin":0.034,
      "maintainMargin":0.017,
      "maxRiskLimit":10000,
      "minRiskLimit":10000,
      "riskStep":5000,
      "makerFeeRate":0.0002,
      "takerFeeRate":0.0006,
      "takerFixFee":0.0,
      "makerFixFee":0.0,
      "settlementFee":null,
      "isDeleverage":true,
      "isQuanto":false,
      "isInverse":false,
      "markMethod":"FairPrice",
      "fairMethod":"FundingRate",
      "fundingBaseSymbol":".XEMINT8H",
      "fundingQuoteSymbol":".USDTINT8H",
      "fundingRateSymbol":".XEMUSDTMFPI8H",
      "indexSymbol":".KXEMUSDT",
      "settlementSymbol":"",
      "status":"Open",
      "fundingFeeRate":7.2e-5,
      "predictedFundingFeeRate":-1.5e-5,
      "openInterest":"14240708",
      "turnoverOf24h":39512.89870461,
      "volumeOf24h":1.114053e6,
      "markPrice":0.03541,
      "indexPrice":0.03541,
      "lastTradePrice":0.03535,
      "nextFundingRateTime":12755619,
      "maxLeverage":30,
      "sourceExchanges":[
        "binance",
        "okex",
        "kucoin",
        "bitget",
        "gateio"
      ],
      "premiumsSymbol1M":".XEMUSDTMPI",
      "premiumsSymbol8H":".XEMUSDTMPI8H",
      "fundingBaseSymbol1M":".XEMINT",
      "fundingQuoteSymbol1M":".USDTINT",
      "lowPrice":0.03469,
      "highPrice":0.03585,
      "priceChgPct":-0.0106,
      "priceChg":-0.00038
    },
   ...
  ]
}
```
"""
function contract(client::KucoinClient, query::ContractQuery)
    return APIsRequest{Data{Vector{ContractData}}}("GET", "api/v1/contracts/active", query)(client)
end

function contract(client::KucoinClient = Kucoin.Futures.public_client; kw...)
    return contract(client, ContractQuery(; kw...))
end

end
