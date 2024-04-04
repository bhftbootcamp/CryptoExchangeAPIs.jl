module FeeEstimate

export FeeEstimateQuery,
    FeeEstimateData,
    fee_estimate

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Coinbase
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct FeeEstimateQuery <: CoinbasePublicQuery
    currency::Maybe{String} = nothing
    crypto_address::Maybe{String} = nothing
    network::Maybe{String} = nothing
end

struct FeeEstimateData <: CoinbaseData
    fee::Maybe{String}
    fee_before_subsidy::Maybe{String}
end

"""
    fee_estimate(client::CoinbaseClient, query::FeeEstimateQuery)
    fee_estimate(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)

Gets the fee estimate for the crypto withdrawal to crypto address.

[`GET withdrawals/fee-estimate`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getwithdrawfeeestimate)

## Parameters:

| Parameter      | Type         | Required | Description |
|:---------------|:-------------|:---------|:------------|
| currency       | String       | false    |             |
| crypto_address | String       | false    |             |
| network        | String       | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Coinbase

result = Coinbase.Spot.fee_estimate()

to_pretty_json(result.result)
```

## Result:

"""
function fee_estimate(client::CoinbaseClient, query::FeeEstimateQuery)
    return APIsRequest{FeeEstimateData}("GET", "withdrawals/fee-estimate", query)(client)
end

function fee_estimate(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)
    return fee_estimate(client, FeeEstimateQuery(; kw...))
end

end