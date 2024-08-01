module Currency

export CurrencyQuery,
    CurrencyData,
    currency

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CurrencyQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing        # The 'Public Key' in your API Key
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing    # The Hash method that is used to sign, it uses HmacSHA256
    SignatureVersion::Maybe{String} = nothing   # The version for the Signature protocol, it uses 2
    Timestamp::Maybe{DateTime} = nothing

    authorizedUser::Maybe{Bool} = nothing       # Authorized user true or false (if not filled, default value is true)
    currency::Maybe{String} = nothing           # btc, ltc, bch, eth, etc ...(available currency in Huobi)
end

@enum WithdrawDepositStatus begin
    allowed
    prohibited
end

@enum WithdrawFeeType begin
    fixed
    circulated
    ratio
end

struct Chain <: HuobiData
    baseChain::Maybe{String}
    baseChainProtocol::Maybe{String}
    chain::Maybe{String}
    depositStatus::Maybe{WithdrawDepositStatus}
    displayName::Maybe{String}
    isDynamic::Maybe{Bool}
    maxTransactFeeWithdraw::Maybe{Float64}
    maxWithdrawAmt::Maybe{Float64}
    minDepositAmt::Maybe{Float64}
    minTransactFeeWithdraw::Maybe{Float64}
    minWithdrawAmt::Maybe{Float64}
    numOfConfirmations::Maybe{Int64}
    numOfFastConfirmations::Maybe{Int64}
    transactFeeRateWithdraw::Maybe{Float64}
    transactFeeWithdraw::Maybe{Float64}
    withdrawFeeType::Maybe{WithdrawFeeType}
    withdrawPrecision::Maybe{Int64}
    withdrawQuotaPerDay::Maybe{Float64}
    withdrawQuotaPerYear::Maybe{Float64}
    withdrawQuotaTotal::Maybe{Float64}
    withdrawStatus::Maybe{WithdrawDepositStatus}
end

struct CurrencyData <: HuobiData
    chains::Vector{Chain}
    currency::String
    instStatus::String
end

"""
    currency(client::HuobiClient, query::CurrencyQuery)
    currency(client::HuobiClient; kw...)

API user could query static reference information for each currency, as well as its corresponding chain(s).

[`GET v2/reference/currencies`](https://www.htx.com/en-in/opend/newApiPages/?id=7ec516fc-7773-11ed-9966-0242ac110003)

## Parameters:

| Parameter        | Type     | Required | Description |
|:-----------------|:---------|:---------|:------------|
| AccessKeyId      | String   | false    |             |
| Signature        | String   | false    |             |
| SignatureMethod  | String   | false    |             |
| SignatureVersion | String   | false    |             |
| Timestamp        | DateTime | false    |             |
| authorizedUser   | Bool     | false    |             |
| currency         | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Huobi

huobi_client = CryptoExchangeAPIs.Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.Spot.currency(
    huobi_client;
    currency = "usdt",
    authorizedUser = true,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200
  "data":[
    {
      "chains":[
        {
          "chain":"trc20usdt",
          "displayName":"",
          "baseChain":"TRX",
          "baseChainProtocol":"TRC20",
          "isDynamic":false,
          "depositStatus":"allowed",
          "maxTransactFeeWithdraw":1.0,
          "maxWithdrawAmt":280000.0,
          "minDepositAmt":100.0,
          "minTransactFeeWithdraw":0.1,
          "minWithdrawAmt":0.01,
          "numOfConfirmations":999.0,
          "numOfFastConfirmations":999.0,
          "withdrawFeeType":"circulated",
          "withdrawPrecision":5.0,
          "withdrawQuotaPerDay":280000.0,
          "withdrawQuotaPerYear":2800000.0,
          "withdrawQuotaTotal":2800000.0,
          "withdrawStatus":"allowed",
        },
        ...
      ]
      "currency":"usdt"
      "instStatus":"normal"
    },
    ...
  ]
}
```
"""
function currency(client::HuobiClient, query::CurrencyQuery)
    return APIsRequest{Data{Vector{CurrencyData}}}("GET", "v2/reference/currencies", query)(client)
end

function currency(client::HuobiClient; kw...)
    return currency(client, CurrencyQuery(; kw...))
end

end
