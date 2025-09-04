module WithdrawHistory

export WithdrawHistoryQuery,
    WithdrawHistoryData,
    withdraw_history

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx WithdrawStatus begin
    EMAIL_SENT = 0
    CANCELLED = 1
    AWAITING_APPROVAL = 2
    REJECTED = 3
    PROCESSING = 4
    FAILURE = 5
    COMPLETED = 6
end

Base.@kwdef mutable struct WithdrawHistoryQuery <: BinancePrivateQuery
    coin::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = 1000
    offset::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    status::Maybe{WithdrawStatus.T} = nothing
    withdrawOrderId::Maybe{String} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:WithdrawHistoryQuery}, x::WithdrawStatus.T)::Int64
    return Int64(x)
end

struct WithdrawHistoryData <: BinanceData
    address::String
    amount::Float64
    applyTime::NanoDate
    coin::String
    confirmNo::Maybe{Int64}
    id::String
    info::String
    network::String
    status::WithdrawStatus.T
    transactionFee::Float64
    transferType::Int64
    txId::Maybe{String}
    txKey::Maybe{String}
    walletType::Int64
    completeTime::Maybe{NanoDate}
end

"""
    withdraw_history(client::BinanceClient, query::WithdrawHistoryQuery)
    withdraw_history(client::BinanceClient; kw...)

Fetch withdraw history.

[`GET sapi/v1/capital/withdraw/history`](https://binance-docs.github.io/apidocs/spot/en/#withdraw-history-supporting-network-user_data)

## Parameters:

| Parameter       | Type           | Required | Description                                                                                                        |
|:----------------|:---------------|:---------|:-------------------------------------------------------------------------------------------------------------------|
| coin            | String         | false    |                                                                                                                    |
| endTime         | DateTime       | false    |                                                                                                                    |
| limit           | Int64          | false    | Default: 1000                                                                                                      |
| offset          | Int64          | false    |                                                                                                                    |
| startTime       | DateTime       | false    |                                                                                                                    |
| status          | WithdrawStatus | false    | EMAIL\\_SENT (0), CANCELLED (1), AWAITING\\_APPROVAL (2), REJECTED (3), PROCESSING (4), FAILURE (5), COMPLETED (6) |
| withdrawOrderId | String         | false    |                                                                                                                    |
| recvWindow      | Int64          | false    |                                                                                                                    |
| signature       | String         | false    |                                                                                                                    |
| timestamp       | DateTime       | false    |                                                                                                                    |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.Spot.SAPI.V1.Capital.withdraw_history(binance_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":"b6ae22b3aa844210a7041aee7589627c",
    "amount":8.91000000,
    "transactionFee":0.004,
    "coin":"USDT",
    "status":6,
    "address":"0x94df8b352de7f46f64b01d3666bf6e936e44ce60",
    "txId":"0xb5ef8c13b968a406cc62a93a8bd80f9e9a906ef1b3fcf20a2e48573c17659268"
    "applyTime":"2019-10-12T11:12:02",
    "network":"ETH",
    "transferType":0,
    "info":"",
    "confirmNo":3,
    "walletType":1,
    "txKey":"",
    "completeTime":"2023-03-23T16:52:41"
  },
  ...
]
```
"""
function withdraw_history(client::BinanceClient, query::WithdrawHistoryQuery)
    return APIsRequest{Vector{WithdrawHistoryData}}("GET", "sapi/v1/capital/withdraw/history", query)(client)
end

function withdraw_history(client::BinanceClient; kw...)
    return withdraw_history(client, WithdrawHistoryQuery(; kw...))
end

end 
