module WithdrawalsFeeEstimate

export WithdrawalsFeeEstimateQuery,
    WithdrawalsFeeEstimateData,
    withdrawals_fee_estimate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawalsFeeEstimateQuery <: CoinbasePrivateQuery
    currency::Maybe{String} = nothing
    crypto_address::Maybe{String} = nothing
    network::Maybe{String} = nothing

    timestamp::Maybe{String} = nothing
    signature::Maybe{String} = nothing
end

struct WithdrawalsFeeEstimateData <: CoinbaseData
    fee::Maybe{Float64}
    fee_before_subsidy::Maybe{Float64}
end

"""
    withdrawals_fee_estimate(client::CoinbaseClient, query::WithdrawalsFeeEstimateQuery)
    withdrawals_fee_estimate(client::CoinbaseClient; kw...)

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

result = Coinbase.ExchangeAPI.withdrawals_fee_estimate(coinbase_client)

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
function withdrawals_fee_estimate(client::CoinbaseClient, query::WithdrawalsFeeEstimateQuery)
    return APIsRequest{WithdrawalsFeeEstimateData}("GET", "withdrawals/fee-estimate", query)(client)
end

function withdrawals_fee_estimate(client::CoinbaseClient; kw...)
    return withdrawals_fee_estimate(client, WithdrawalsFeeEstimateQuery(; kw...))
end

end
