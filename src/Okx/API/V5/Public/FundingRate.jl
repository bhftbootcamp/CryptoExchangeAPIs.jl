module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateQuery <: OkxPublicQuery
    instId::String
end

struct FundingRateData <: OkxData
    fundingRate::Maybe{Float64}
    fundingTime::Maybe{NanoDate}
    instId::Maybe{String}
    instType::Maybe{String}
    maxFundingRate::Maybe{Float64}
    method::Maybe{String}
    minFundingRate::Maybe{Float64}
    nextFundingRate::Maybe{Float64}
    nextFundingTime::Maybe{NanoDate}
    premium::Maybe{Float64}
    settFundingRate::Maybe{Float64}
    settState::Maybe{String}
    ts::Maybe{NanoDate}
end

function Serde.isempty(::Type{FundingRateData}, x)
    return x === ""
end

"""
    funding_rate(client::OkxClient, query::FundingRateQuery)
    funding_rate(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

Retrieve the current funding rate of a SWAP instrument.

[`GET api/v5/public/funding-rate`](https://www.okx.com/docs-v5/en/#public-data-rest-api-get-funding-rate)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| instId    | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Public.funding_rate(;
    instId = "BTC-USDT-SWAP",
)
```
"""
function funding_rate(client::OkxClient, query::FundingRateQuery)
    return APIsRequest{Data{FundingRateData}}("GET", "api/v5/public/funding-rate", query)(client)
end

function funding_rate(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
