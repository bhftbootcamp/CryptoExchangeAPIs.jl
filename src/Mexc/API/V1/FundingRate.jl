module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateQuery <: MexcPublicQuery
    symbol::String
end

Serde.SerQuery.ser_ignore_field(::Type{FundingRateQuery}, ::Val{:symbol}) = true

struct FundingRateData <: MexcData
    symbol::Maybe{String}
    fundingRate::Maybe{Float64}
    maxFundingRate::Maybe{Float64}
    minFundingRate::Maybe{Float64}
    collectCycle::Maybe{Int64}
    nextSettleTime::Maybe{NanoDate}
    timestamp::Maybe{NanoDate}
end

"""
    funding_rate(client::MexcClient, query::FundingRateQuery)
    funding_rate(client::MexcClient = MexcFuturesClient(Mexc.public_futures_config); kw...)

Get contract funding rate.

[`GET api/v1/contract/funding_rate/{symbol}`](https://mexcdevelop.github.io/apidocs/contract_v1_en/#get-contract-funding-rate)

## Parameters:

| Parameter | Type   | Required | Description              |
|:----------|:-------|:---------|:-------------------------|
| symbol    | String | true     | Contract name, e.g. BTC_USDT |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V1.funding_rate(;
    symbol = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "success":true,
  "code":0,
  "data":{
    "symbol":"BTC_USDT",
    "fundingRate":-0.000489,
    "maxFundingRate":0.001,
    "minFundingRate":-0.001,
    "collectCycle":8,
    "nextSettleTime":"2021-01-05T08:00:00",
    "timestamp":"2021-01-05T06:56:47.577000000"
  }
}
```
"""
function funding_rate(client::MexcClient, query::FundingRateQuery)
    return APIsRequest{FuturesData{FundingRateData}}("GET", "api/v1/contract/funding_rate/$(query.symbol)", query)(client)
end

function funding_rate(client::MexcClient = MexcFuturesClient(Mexc.public_futures_config); kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
