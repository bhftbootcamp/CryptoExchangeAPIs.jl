module HistoricalOrders

export HistoricalOrdersQuery,
    HistoricalOrdersData,
    HistoricalOrderInfo,
    historical_orders

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct HistoricalOrdersQuery <: HyperliquidPublicQuery
    type::String = "historicalOrders"
    user::String
end

struct OrderInfo <: HyperliquidData
    coin::String
    side::String
    limitPx::String
    sz::String
    oid::Int
    timestamp::NanoDate
    triggerCondition::String
    isTrigger::Bool
    triggerPx::String
    children::Vector{Any}
    isPositionTpsl::Bool
    reduceOnly::Bool
    orderType::String
    origSz::String
    tif::String
    cloid::Maybe{String}
end

struct HistoricalOrderInfo <: HyperliquidData
    order::OrderInfo
    status::String
    statusTimestamp::NanoDate
end

const HistoricalOrdersData = Vector{HistoricalOrderInfo}

"""
    historical_orders(client::HyperliquidClient, query::HistoricalOrdersQuery)
    historical_orders(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's historical orders. Returns at most 2000 most recent historical orders.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-historical-orders)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.historical_orders(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function historical_orders(client::HyperliquidClient, query::HistoricalOrdersQuery)
    return APIsRequest{HistoricalOrdersData}("POST", "info", query)(client)
end

function historical_orders(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return historical_orders(client, HistoricalOrdersQuery(; kw...))
end

end

