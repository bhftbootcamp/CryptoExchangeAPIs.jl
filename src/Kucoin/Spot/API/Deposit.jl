module Deposit

export DepositQuery,
    DepositData,
    deposit

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kucoin
using CryptoAPIs.Kucoin: Data, Page
using CryptoAPIs: Maybe, APIsRequest

@enum Status begin
    PROCESSING
    SUCCESS
    FAILURE
end

Base.@kwdef mutable struct DepositQuery <: KucoinPrivateQuery
    currency::Maybe{String} = nothing
    endAt::Maybe{DateTime} = nothing
    startAt::Maybe{DateTime} = nothing
    status::Maybe{Status} = nothing

    passphrase::Maybe{String} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct DepositData <: KucoinData
    amount::Float64
    createAt::NanoDate
    currency::String
    isInner::Bool
    status::String
    walletTxId::String
end

"""
    deposit(client::KucoinClient, query::DepositQuery)
    deposit(client::KucoinClient; kw...)

equest via this endpoint to get the V1 historical deposits list on KuCoin.

[`GET api/v1/hist-deposits`](https://docs.kucoin.com/#get-v1-historical-deposits-list)

## Parameters:

| Parameter  | Type     | Required | Description |
|:---------- |:---------|:---------|:------------|
| currency   | String   | false    |             |
| endAt      | DateTime | false    |             |
| startAt    | DateTime | false    |             |
| status     | Status   | false    |             |
| passphrase | String   | false    |             |
| signature  | String   | false    |             |
| timestamp  | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kucoin

kucoin_client = KucoinClient(;
    base_url = "https://api.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

result = Kucoin.Spot.deposit(
    kucoin_client;
    currency = "BTC",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "pageSize":1,
  "totalNum":9,
  "currentPage":1,
  "totalPage":9,
  "items":[
    {
      "amount":0.03266638,
      "createAt":"1970-01-18T16:35:36.998",
      "currency":"BTC",
      "isInner":false,
      "status":"SUCCESS",
      "walletTxId":"55c643bc2c68d6f17266383ac1be9e454038864b929ae7cee0bc408cc5c869e8"
    }
  ]
}
```
"""
function deposit(client::KucoinClient, query::DepositQuery)
    return APIsRequest{Data{Page{DepositData}}}("GET", "api/v1/hist-deposits", query)(client)
end

function deposit(client::KucoinClient; kw...)
    return deposit(client, DepositQuery(; kw...))
end

end
