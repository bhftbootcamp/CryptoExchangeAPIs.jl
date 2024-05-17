module DepositWithdrawal

export DepositWithdrawalQuery,
    DepositWithdrawalData,
    deposit_withdrawal

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Poloniex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositWithdrawalQuery <: PoloniexPrivateQuery
    _end::DateTime
    start::DateTime
    activityType::Maybe{String} = nothing

    signTimestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

function Serde.SerQuery.ser_name(::Type{<:DepositWithdrawalQuery}, ::Val{:_end})::String
    return "end"
end

@enum Status begin
    PENDING
    PROCESSING
    AWAITING
    APPROVAL
    COMPLETED
    COMPLETE_ERROR
end

struct WithdrawalLog <: PoloniexData
    address::Float64
    amount::Float64
    currency::String
    fee::Float64
    ipAddress::String
    paymentID::String
    status::Status
    timestamp::NanoDate
    txid::String
    withdrawalRequestsId::Int64
end

struct DepositLog <: PoloniexData
    address::Union{Float64,String}
    amount::Float64
    confirmations::Int64
    currency::String
    depositNumber::Int64
    status::String
    timestamp::NanoDate
    txid::String
end

struct DepositWithdrawalData
    deposits::Maybe{Vector{DepositLog}}
    withdrawals::Maybe{Vector{WithdrawalLog}}
end

"""
    deposit_withdrawal(client::PoloniexClient, query::DepositWithdrawalQuery)
    deposit_withdrawal(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get deposit and withdrawal activity history within a range window for a user.

[`GET wallets/activity`](https://api-docs.poloniex.com/spot/api/private/wallet#wallets-activity-records)

## Parameters:

| Parameter     | Type     | Required | Description |
|:--------------|:---------|:---------|:------------|
| _end          | DateTime | true     |             |
| start         | DateTime | true     |             |
| activityType  | String   | false    |             |
| signTimestamp | DateTime | false    |             |
| signature     | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Poloniex

poloniex_client = CryptoAPIs.Poloniex.PoloniexClient(;
    base_url = "https://api.poloniex.com",
    public_key = ENV["POLONIEX_PUBLIC_KEY"],
    secret_key = ENV["POLONIEX_SECRET_KEY"],
)

result = Poloniex.Spot.deposit_withdrawal(;
    poloniex_client;
    start = Dates.DateTime("2022-04-03T15:33:20"),
    _end = Dates.DateTime("2022-07-28T09:20:00"),
)

to_pretty_json(result.result)
```

## Result:

```json
{ 
  "deposits":[ 
    { 
      "depositNumber":7397520,
      "currency":"BTC",
      "address":"131rdg5Rzn6BFufnnQaHhVa5ZtRU1J2EZR",
      "amount":0.06830697,
      "confirmations":1,
      "txid":"3a4b9b2404f6e6fb556c3e1d46a9752f5e70a93ac1718605c992b80aacd8bd1d",
      "timestamp":"2022-04-03T15:33:20",
      "status":"COMPLETED"
    },
    ... 
  ],
  "withdrawals":[ 
    { 
      "withdrawalRequestsId":7397527,
      "currency":"ETC",
      "address":"0x26419a62055af459d2cd69bb7392f5100b75e304",
      "amount":13.199516,
      "fee":0.01,
      "timestamp":"2022-04-03T15:33:20",
      "status":"COMPLETED",
      "txid":"343346392f82ac16e8c2604f2a604b7b2382d0e9d8030f673821f8de4b5f5bk",
      "ipAddress":"1.2.3.4",
      "paymentID":null
    },
    ...
  ]
}
```
"""
function deposit_withdrawal(client::PoloniexClient, query::DepositWithdrawalQuery)
    return APIsRequest{DepositWithdrawalData}("GET", "wallets/activity", query)(client)
end

function deposit_withdrawal(client::PoloniexClient; kw...)
    return deposit_withdrawal(client, DepositWithdrawalQuery(; kw...))
end

end
