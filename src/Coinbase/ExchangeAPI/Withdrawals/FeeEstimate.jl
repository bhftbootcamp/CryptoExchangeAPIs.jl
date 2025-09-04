module FeeEstimate

export FeeEstimateQuery,
    FeeEstimateData,
    fee_estimate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct FeeEstimateQuery <: CoinbasePrivateQuery
    currency::Maybe{String} = nothing
    crypto_address::Maybe{String} = nothing
    network::Maybe{String} = nothing

    timestamp::Maybe{String} = nothing
    signature::Maybe{String} = nothing
end

struct FeeEstimateData <: CoinbaseData
    fee::Maybe{Float64}
    fee_before_subsidy::Maybe{Float64}
end

"""
    fee_estimate(client::CoinbaseClient, query::FeeEstimateQuery)
    fee_estimate(client::CoinbaseClient; kw...)

Gets the fee estimate for the crypto withdrawal to crypto address.

[`GET withdrawals/fee-estimate`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getwithdrawfeeestimate)

## Parameters:

| Parameter      | Type         | Required | Description |
|:---------------|:-------------|:---------|:------------|
| currency       | String       | false    |             |
| crypto_address | String       | false    |             |
| network        | String       | false    |             |
| signature      | String       | false    |             |
| timestamp      | String       | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

coinbase_client = CoinbaseClient(;
    base_url = "https://api.exchange.coinbase.com",
    public_key = ENV["COINBASE_PUBLIC_KEY"],
    secret_key = ENV["COINBASE_SECRET_KEY"],
    passphrase = ENV["COINBASE_PASSPHRASE"],
)

result = Coinbase.ExchangeAPI.Withdrawals.fee_estimate(coinbase_client)

to_pretty_json(result.result)
```

## Result:

```json
{
  "fee":0.1,
  "fee_before_subsidy":0.01
}
```
"""
function fee_estimate(client::CoinbaseClient, query::FeeEstimateQuery)
    return APIsRequest{FeeEstimateData}("GET", "withdrawals/fee-estimate", query)(client)
end

function fee_estimate(client::CoinbaseClient; kw...)
    return fee_estimate(client, FeeEstimateQuery(; kw...))
end

end
