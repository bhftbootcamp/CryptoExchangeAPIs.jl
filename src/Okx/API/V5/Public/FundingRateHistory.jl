module FundingRateHistory

export FundingRateHistoryQuery,
    FundingRateHistoryData,
    funding_rate_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateHistoryQuery <: OkxPublicQuery
    instId::String
    after::Maybe{DateTime} = nothing
    before::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

struct FundingRateHistoryData <: OkxData
    fundingRate::Maybe{Float64}
    fundingTime::Maybe{NanoDate}
    instId::Maybe{String}
    instType::Maybe{String}
    method::Maybe{String}
    realizedRate::Maybe{Float64}
end

function Serde.isempty(::Type{FundingRateHistoryData}, x)
    return x === ""
end

"""
    funding_rate_history(client::OkxClient, query::FundingRateHistoryQuery)
    funding_rate_history(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

Retrieve funding rate history. Only data from the last 3 months is available.

[`GET api/v5/public/funding-rate-history`](https://www.okx.com/docs-v5/en/#public-data-rest-api-get-funding-rate-history)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| instId    | String   | true     |             |
| after     | DateTime | false    |             |
| before    | DateTime | false    |             |
| limit     | Int64    | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Public.funding_rate_history(;
    instId = "BTC-USDT-SWAP",
)
```
"""
function funding_rate_history(client::OkxClient, query::FundingRateHistoryQuery)
    return APIsRequest{Data{FundingRateHistoryData}}("GET", "api/v5/public/funding-rate-history", query)(client)
end

function funding_rate_history(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return funding_rate_history(client, FundingRateHistoryQuery(; kw...))
end

end
