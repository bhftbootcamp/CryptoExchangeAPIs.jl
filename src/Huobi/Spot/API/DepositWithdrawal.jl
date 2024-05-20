module DepositWithdrawal

export DepositWithdrawalQuery,
    DepositWithdrawalData,
    deposit_withdrawal

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Huobi
using CryptoAPIs.Huobi: Data
using CryptoAPIs: Maybe, APIsRequest

@enum DirectQuery begin
    prev
    next
end

Base.@kwdef mutable struct DepositWithdrawalQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing            # The 'Public Key' in your API Key
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing        # The Hash method that is used to sign, it uses HmacSHA256
    SignatureVersion::Maybe{String} = nothing       # The version for the signature protocol, it uses 2
    Timestamp::Maybe{DateTime} = nothing

    currency::Maybe{String} = nothing               # The crypto currency to withdraw
    direct::Maybe{DirectQuery} = nothing            # the order of response 'prev' (ascending), 'next' (descending) 'prev'
    from::Maybe{String} = nothing                   # The transfer id to begin search
    size::Maybe{Int64} = nothing                    # The number of items to return [1-500] deault 100
    type::String                                    # Define transfer type to search: deposit, withdraw, sub user can only use deposit
end

struct DepositWithdrawalData <: HuobiData
    address::Maybe{String}
    address_tag::Maybe{String}
    amount::Maybe{Int64}
    chain::Maybe{String}
    created_at::NanoDate
    currency::Maybe{String}
    fee::Maybe{Int64}
    from_addr_tag::Maybe{String}
    id::Int64
    state::Maybe{String}
    sub_type::Maybe{String}
    tx_hash::Maybe{String}
    type::Maybe{String}
    updated_at::Maybe{NanoDate}
end

"""
    deposit_withdrawal(client::HuobiClient, query::DepositWithdrawalQuery)
    deposit_withdrawal(client::HuobiClient; kw...)

Parent user and sub user search for all existed withdraws and deposits and return their latest status.

[`GET v1/query/deposit-withdraw`](https://huobiapi.github.io/docs/spot/v1/en/#search-for-existed-withdraws-and-deposits)

## Parameters:

| Parameter        | Type        | Required | Description   |
|:-----------------|:------------|:---------|:--------------|
| type             | String      | true     |               |
| AccessKeyId      | String      | false    |               |
| Signature        | String      | false    |               |
| SignatureMethod  | String      | false    |               |
| SignatureVersion | String      | false    |               |
| Timestamp        | DateTime    | false    |               |
| currency         | String      | false    |               |
| direct           | DirectQuery | false    | `prev` `next` |
| from             | String      | false    |               |
| size             | Int64       | false    |               |

## Code samples:

```julia
using Serde
using CryptoAPIs.Huobi

huobi_client = CryptoAPIs.Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.Spot.deposit_withdrawal(
    huobi_client;
    currency = "usdt",
    from = "1",
    size = 500,
    type = "withdraw",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "data":[
    {
      "id":45182894,
      "type":"withdraw",
      "sub-type":"FAST",
      "currency":"usdt",
      "chain":"trc20usdt",
      "tx-hash":"",
      "amount":400,
      "from-addr-tag":"",
      "address":"TRwkUYHWgUh23jbKpgTcYHgE9CcBzhGno9",
      "address-tag":"",
      "fee":0,
      "state":"confirmed",
      "created-at":"2021-02-02T10:22:10",
      "updated-at":"2021-02-02T10:23:09"
    },
    ...
  ]
}
```
"""
function deposit_withdrawal(client::HuobiClient, query::DepositWithdrawalQuery)
    return APIsRequest{Data{DepositWithdrawalData}}("GET", "v1/query/deposit-withdraw", query)(client)
end

function deposit_withdrawal(client::HuobiClient; kw...)
    return deposit_withdrawal(client, DepositWithdrawalQuery(; kw...))
end

end