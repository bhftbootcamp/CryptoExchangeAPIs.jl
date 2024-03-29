module DepositLog

export DepositLogQuery,
    DepositLogData,
    deposit_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum DepositStatus begin
    PENDING = 0
    SUCCESS = 1
    CREDITED_BUT_CANNOT_WITHDRAW = 6
    WRONG_DEPOSIT = 7
    WAITING_USER_CONFIRM = 8
end

Base.@kwdef mutable struct DepositLogQuery <: BinancePrivateQuery
    coin::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = 1000
    offset::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    status::Maybe{DepositStatus} = nothing
    txId::Maybe{String} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:DepositLogQuery}, x::DepositStatus)::Int64
    return Int64(x)
end

struct DepositLogData <: BinanceData
    address::String
    addressTag::String
    amount::Float64
    coin::String
    confirmTimes::String
    id::Int64
    insertTime::NanoDate
    network::String
    status::DepositStatus
    transferType::Int64
    txId::Maybe{String}
    unlockConfirm::Int64
    walletType::Int64
end

"""
    deposit_log(client::BinanceClient, query::DepositLogQuery)
    deposit_log(client::BinanceClient; kw...)

Fetch deposit history.

[`GET sapi/v1/capital/withdraw/history`](https://binance-docs.github.io/apidocs/spot/en/#deposit-history-supporting-network-user_data)

## Parameters:

| Parameter  | Type          | Required | Description   |
|:-----------|:--------------|:---------|:--------------|
| coin       | String        | false    |               |
| endTime    | DateTime      | false    |               |
| limit      | Int64         | false    | Default: 1000 |
| offset     | Int64         | false    |               |
| startTime  | DateTime      | false    |               |
| status     | DepositStatus | false    |               |
| txId       | String        | false    |               |
| recvWindow | Int64         | false    |               |
| timestamp  | DateTime      | false    |               |
| signature  | String        | false    |               |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.Spot.deposit_log(binance_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id": "b6ae22b3aa844210a7041aee7589627c",
    "amount": "8.91000000",
    "transactionFee": "0.004",
    "coin": "USDT",
    "status": 6,
    "address": "0x94df8b352de7f46f64b01d3666bf6e936e44ce60",
    "txId": "0xb5ef8c13b968a406cc62a93a8bd80f9e9a906ef1b3fcf20a2e48573c17659268",
    "applyTime": "2019-10-12 11:12:02",
    "network": "ETH",
    "transferType": 0,
    "withdrawOrderId": "WITHDRAWtest123",
    "info": "The address is not valid. Please confirm with the recipient",
    "confirmNo":3,
    "walletType": 1,
    "txKey": "",
    "completeTime": "2023-03-23 16:52:41"
  },
  ...
]
```
"""
function deposit_log(client::BinanceClient, query::DepositLogQuery)
    return APIsRequest{Vector{DepositLogData}}("GET", "sapi/v1/capital/deposit/hisrec", query)(client)
end

function deposit_log(client::BinanceClient; kw...)
    return deposit_log(client, DepositLogQuery(; kw...))
end

end
