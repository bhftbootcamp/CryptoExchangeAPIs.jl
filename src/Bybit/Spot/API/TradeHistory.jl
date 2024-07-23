module TradeHistory

export TradeHistoryQuery, 
    TradeHistoryData, 
    trade_history

using Serde
using Dates
using CryptoAPIs.Bybit
using CryptoAPIs.Bybit: Data, List
using CryptoAPIs: Maybe, APIsRequest

@enum TradeCategory OPTION SPOT LINEAR INVERSE

Base.@kwdef mutable struct TradeHistoryQuery <: BybitPrivateQuery
    category::TradeCategory
    symbol::Maybe{String} = nothing
    orderId::Maybe{String} = nothing
    orderLinkId::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    execType::Maybe{String} = nothing
    limit::Int64 = 50
    cursor::Maybe{String} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Maybe{Int64} = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:BybitPrivateQuery}, x::TradeCategory)::String
    x == OPTION  && return "option"
    x == SPOT  && return "spot"
    x == LINEAR  && return "linear"
    x == INVERSE && return "inverse"
end

struct TradeHistoryData <: BybitData
    symbol::String
    orderId::String
    orderLinkId::Maybe{String}
    side::String
    orderPrice::String
    orderQty::String
    leavesQty::Maybe{String}
    createType::Maybe{String}
    orderType::String
    stopOrderType::Maybe{String}
    execFee::String
    execId::String
    execPrice::String
    execQty::String
    execType::Maybe{String}
    execValue::Maybe{String}
    execTime::String
    feeCurrency::Maybe{String}
    isMaker::Bool
    feeRate::Maybe{String}
    tradeIv::Maybe{String}
    markIv::Maybe{String}
    markPrice::Maybe{String}
    indexPrice::Maybe{String}
    underlyingPrice::Maybe{String}
    blockTradeId::Maybe{String}
    closedSize::Maybe{String}
    seq::Maybe{Int64}
end

function Serde.isempty(::Type{<:TradeHistoryData}, x)::Bool
    return x === ""
end

"""
    trade_history(client::BybitClient, query::TradeHistoryQuery)
    trade_history(client::BybitClient; kw...)

Query users' execution records.

[`GET /v5/execution/list`](https://bybit-exchange.github.io/docs/v5/order/execution)

## Parameters:

| Parameter   | Type     | Required | Description           |
|:------------|:---------|:---------|:----------------------|
| category    | String   | true     |                       |
| symbol      | String   | false    |                       |
| orderId     | String   | false    |                       |
| orderLinkId | String   | false    |                       |
| baseCoin    | String   | false    |                       |
| endTime     | DateTime | false    |                       |
| limit       | Int64    | false    | Default: 50, Max: 100 |
| startTime   | DateTime | false    |                       |
| execType    | String   | false    |                       |
| cursor      | String   | false    |                       |
| api_key     | String   | false    |                       |
| recv_window | Int64    | false    | Default: 5000         |
| signature   | String   | false    |                       |
| timestamp   | DateTime | false    |                       |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bybit

bybit_client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.Spot.trade_history(
    bybit_client;
    category = Bybit.Spot.TradeHistory.LINEAR,
    limit = 1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
    "retCode": 0,
    "retMsg": "OK",
    "result": {
        "nextPageCursor": "132766%3A2%2C132766%3A2",
        "category": "linear",
        "list": [
            {
                "symbol": "ETHPERP",
                "orderType": "Market",
                "underlyingPrice": "",
                "orderLinkId": "",
                "side": "Buy",
                "indexPrice": "",
                "orderId": "8c065341-7b52-4ca9-ac2c-37e31ac55c94",
                "stopOrderType": "UNKNOWN",
                "leavesQty": "0",
                "execTime": "1672282722429",
                "feeCurrency": "",
                "isMaker": false,
                "execFee": "0.071409",
                "feeRate": "0.0006",
                "execId": "e0cbe81d-0f18-5866-9415-cf319b5dab3b",
                "tradeIv": "",
                "blockTradeId": "",
                "markPrice": "1183.54",
                "execPrice": "1190.15",
                "markIv": "",
                "orderQty": "0.1",
                "orderPrice": "1236.9",
                "execValue": "119.015",
                "execType": "Trade",
                "execQty": "0.1",
                "closedSize": "",
                "seq": 4688002127
            }
        ]
    },
    "retExtInfo": {},
    "time": 1672283754510
}
```
"""
function trade_history(client::BybitClient, query::TradeHistoryQuery)
    return APIsRequest{Data{List{TradeHistoryData}}}("GET", "/v5/execution/list", query)(client)
end

function trade_history(client::BybitClient; kw...)
    return trade_history(client, TradeHistoryQuery(; kw...))
end

end