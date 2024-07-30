module TradeHistory

export TradeHistoryQuery,
    TradeHistoryData,
    trade_history

using Serde
using Dates, NanoDates

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List
using CryptoExchangeAPIs: Maybe, APIsRequest

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
    x == SPOT    && return "spot"
    x == LINEAR  && return "linear"
    x == INVERSE && return "inverse"
end

@enum TradeSide Buy Sell

@enum TradeOrderType Market Limit

struct TradeHistoryData <: BybitData
    symbol::String
    orderId::String
    orderLinkId::Maybe{String}
    side::TradeSide
    orderPrice::Float64
    orderQty::Float64
    leavesQty::Maybe{Float64}
    createType::Maybe{String}
    orderType::TradeOrderType
    stopOrderType::Maybe{String}
    execFee::Float64
    execId::String
    execPrice::Float64
    execQty::Float64
    execType::Maybe{String}
    execValue::Maybe{Float64}
    execTime::NanoDate
    feeCurrency::Maybe{String}
    isMaker::Bool
    feeRate::Maybe{Float64}
    tradeIv::Maybe{String}
    markIv::Maybe{String}
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    underlyingPrice::Maybe{Float64}
    blockTradeId::Maybe{String}
    closedSize::Maybe{Float64}
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
using CryptoExchangeAPIs.Bybit

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
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "list":[
      {
        "symbol":"ETHPERP",
        "orderType":"Market",
        "underlyingPrice":nothing,
        "orderLinkId":nothing,
        "side":"Buy",
        "indexPrice":nothing,
        "orderId":"8c065341-7b52-4ca9-ac2c-37e31ac55c94",
        "stopOrderType":"UNKNOWN",
        "leavesQty":0.0,
        "execTime":"2022-12-29T02:58:42.428999936",
        "feeCurrency":nothing,
        "isMaker":false,
        "execFee":0.071409,
        "feeRate":0.0006,
        "execId":"e0cbe81d-0f18-5866-9415-cf319b5dab3b",
        "tradeIv":nothing,
        "blockTradeId":nothing,
        "markPrice":1183.54,
        "execPrice":1190.15,
        "markIv":nothing,
        "orderQty":0.1,
        "orderPrice":1236.9,
        "execValue":119.015,
        "execType":"Trade",
        "execQty":0.1,
        "closedSize":nothing,
        "seq":4688002127
      }
    ],
    "nextPageCursor":"132766%3A2%2C132766%3A2",
    "category":"linear",
  },
  "retExtInfo":{},
  "time":"2022-12-29T03:15:54.510"
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