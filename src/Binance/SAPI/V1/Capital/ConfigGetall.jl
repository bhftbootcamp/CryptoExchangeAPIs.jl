module ConfigGetall

export ConfigGetallQuery,
    ConfigGetallData,
    config_getall

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct ConfigGetallQuery <: BinancePrivateQuery
    recvWindow::Maybe{Int64} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Networklist <: BinanceData
    addressRegex::String
    addressRule::Maybe{String}
    busy::Bool
    coin::String
    country::Maybe{String}
    depositDesc::String
    depositDust::Maybe{Float64}
    depositEnable::Bool
    estimatedArrivalTime::NanoDate
    isDefault::Bool
    memoRegex::String
    minConfirm::Int64
    name::String
    network::String
    resetAddressStatus::Bool
    sameAddress::Bool
    specialTips::Maybe{String}
    specialWithdrawTips::Maybe{String}
    unLockConfirm::Int64
    withdrawDesc::String
    withdrawEnable::Bool
    withdrawFee::Float64
    withdrawIntegerMultiple::Float64
    withdrawMax::Float64
    withdrawMin::Float64
end

struct ConfigGetallData <: BinanceData
    coin::String
    depositAllEnable::Bool
    free::Float64
    freeze::Float64
    ipoable::Float64
    ipoing::Float64
    isLegalMoney::Bool
    locked::Float64
    name::String
    networkList::Vector{Networklist}
    storage::Float64
    trading::Bool
    withdrawAllEnable::Bool
    withdrawing::Float64
end

"""
    config_getall(client::BinanceClient, query::ConfigGetallQuery)
    config_getall(client::BinanceClient; kw...)

Get information of coins (available for deposit and withdraw) for user.

[`GET sapi/v1/capital/config/getall`](https://binance-docs.github.io/apidocs/spot/en/#all-coins-39-information-user_data)

## Parameters:

| Parameter  | Type      | Required | Description |
|:-----------|:----------|:---------|:------------|
| recvWindow | Int64     | false    |             |
| signature  | String    | false    |             |
| timestamp  | DateTime  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.SAPI.V1.Capital.config_getall(binance_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "coin":"ADA",
    "depositAllEnable":true,
    "free":0.0,
    "freeze":0.0,
    "ipoable":0.0,
    "ipoing":0.0,
    "isLegalMoney":false,
    "locked":0.0,
    "name":"Cardano",
    "networkList":[
      {
        "addressRegex":"^(([0-9A-Za-z]{57,59})|([0-9A-Za-z]{100,104}))\$",
        "addressRule":null,
        "busy":false,
        "coin":"ADA",
        "country":null,
        "depositDesc":"",
        "depositDust":1.0e-6,
        "depositEnable":true,
        "estimatedArrivalTime":"1970-01-01T00:00:00",
        "isDefault":true,
        "memoRegex":"",
        "minConfirm":30,
        "name":"Cardano",
        "network":"ADA",
        "resetAddressStatus":false,
        "sameAddress":false,
        "specialTips":"",
        "specialWithdrawTips":null,
        "unLockConfirm":0,
        "withdrawDesc":"",
        "withdrawEnable":true,
        "withdrawFee":0.8,
        "withdrawIntegerMultiple":1.0e-6,
        "withdrawMax":5.0e7,
        "withdrawMin":2.0
      }
    ],
    "storage":0.0,
    "trading":true,
    "withdrawAllEnable":true,
    "withdrawing":0.0
  },
  ...
]
```
"""
function config_getall(client::BinanceClient, query::ConfigGetallQuery)
    return APIsRequest{Vector{ConfigGetallData}}("GET", "sapi/v1/capital/config/getall", query)(client)
end

function config_getall(client::BinanceClient; kw...)
    return config_getall(client, ConfigGetallQuery(; kw...))
end

end
