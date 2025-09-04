module DepositHisrec

export DepositHisrecQuery,
    DepositHisrecData,
    deposit_hisrec

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx DepositStatus begin
    PENDING = 0
    SUCCESS = 1
    CREDITED_BUT_CANNOT_WITHDRAW = 6
    WRONG_DEPOSIT = 7
    WAITING_USER_CONFIRM = 8
end

Base.@kwdef mutable struct DepositHisrecQuery <: BinancePrivateQuery
    coin::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = 1000
    offset::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    status::Maybe{DepositStatus.T} = nothing
    txId::Maybe{String} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:DepositHisrecQuery}, x::DepositStatus.T)::Int64
    return Int64(x)
end

struct DepositHisrecData <: BinanceData
    address::String
    addressTag::String
    amount::Float64
    coin::String
    confirmTimes::String
    id::Int64
    insertTime::NanoDate
    network::String
    status::DepositStatus.T
    transferType::Int64
    txId::Maybe{String}
    unlockConfirm::Int64
    walletType::Int64
end

"""
    deposit_hisrec(client::BinanceClient, query::DepositHisrecQuery)
    deposit_hisrec(client::BinanceClient; kw...)

Fetch deposit history.

[`GET sapi/v1/capital/withdraw/history`](https://binance-docs.github.io/apidocs/spot/en/#deposit-history-supporting-network-user_data)

## Parameters:

| Parameter  | Type          | Required | Description                                                                                                        |
|:-----------|:--------------|:---------|:-------------------------------------------------------------------------------------------------------------------|
| coin       | String        | false    |                                                                                                                    |
| endTime    | DateTime      | false    |                                                                                                                    |
| limit      | Int64         | false    | Default: 1000                                                                                                      |
| offset     | Int64         | false    |                                                                                                                    |
| startTime  | DateTime      | false    |                                                                                                                    |
| status     | DepositStatus | false    | PENDING (0), SUCCESS (1), CREDITED\\_BUT\\_CANNOT\\_WITHDRAW (6), WRONG\\_DEPOSIT (7), WAITING\\_USER\\_CONFIRM (8)|
| txId       | String        | false    |                                                                                                                    |
| recvWindow | Int64         | false    |                                                                                                                    |
| timestamp  | DateTime      | false    |                                                                                                                    |
| signature  | String        | false    |                                                                                                                    |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.Spot.SAPI.V1.Capital.deposit_hisrec(binance_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":769800519366885376,
    "amount":0.001,
    "coin":"BNB",
    "network":"BNB",
    "status":0,
    "address":"bnb136ns6lfw4zs5hg4n85vdthaad7hq5m4gtkgf23",
    "addressTag":"101764890",
    "txId":"98A3EA560C6B3336D348B6C83F0F95ECE4F1F5919E94BD006E5BF3BF264FACFC",
    "insertTime":"2022-08-26T05:52:26",
    "transferType":0,
    "confirmTimes":"1/1",
    "unlockConfirm":0,
    "walletType":0
  },
  ...
]
```
"""
function deposit_hisrec(client::BinanceClient, query::DepositHisrecQuery)
    return APIsRequest{Vector{DepositHisrecData}}("GET", "sapi/v1/capital/deposit/hisrec", query)(client)
end

function deposit_hisrec(client::BinanceClient; kw...)
    return deposit_hisrec(client, DepositHisrecQuery(; kw...))
end

end
