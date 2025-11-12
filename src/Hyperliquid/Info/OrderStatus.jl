module OrderStatus

export OrderStatusQuery,
    OrderStatusData,
    order_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OrderStatusQuery <: HyperliquidPublicQuery
    type::String = "orderStatus"
    user::String
    oid::Union{Int,String}  # Can be u64 or 16-byte hex string (cloid)
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

struct OrderStatusInfo <: HyperliquidData
    order::OrderInfo
    status::String
    statusTimestamp::NanoDate
end

struct OrderStatusData <: HyperliquidData
    status::String
    order::Maybe{OrderStatusInfo}
end

"""
    order_status(client::HyperliquidClient, query::OrderStatusQuery)
    order_status(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query order status by oid or cloid.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-order-status-by-oid-or-cloid)

## Parameters:

| Parameter | Type          | Required | Description                                        |
|:----------|:--------------|:---------|:---------------------------------------------------|
| user      | String        | true     | Address in 42-character hexadecimal format         |
| oid       | Int or String | true     | u64 order id or 16-byte hex string (client oid)    |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.order_status(;
    user = "0x0000000000000000000000000000000000000000",
    oid = 91490942
)
```
"""
function order_status(client::HyperliquidClient, query::OrderStatusQuery)
    return APIsRequest{OrderStatusData}("POST", "info", query)(client)
end

function order_status(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return order_status(client, OrderStatusQuery(; kw...))
end

end

