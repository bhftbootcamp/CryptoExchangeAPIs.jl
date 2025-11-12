module FrontendOpenOrders

export FrontendOpenOrdersQuery,
    FrontendOpenOrdersData,
    FrontendOrderData,
    frontend_open_orders

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FrontendOpenOrdersQuery <: HyperliquidPublicQuery
    type::String = "frontendOpenOrders"
    user::String
    dex::Maybe{String} = nothing
end

struct FrontendOrderData <: HyperliquidData
    coin::String
    isPositionTpsl::Bool
    isTrigger::Bool
    limitPx::String
    oid::Int
    orderType::String
    origSz::String
    reduceOnly::Bool
    side::String
    sz::String
    timestamp::NanoDate
    triggerCondition::String
    triggerPx::String
    cloid::Maybe{String}
end

const FrontendOpenOrdersData = Vector{FrontendOrderData}

"""
    frontend_open_orders(client::HyperliquidClient, query::FrontendOpenOrdersQuery)
    frontend_open_orders(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's open orders with additional frontend info.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-open-orders-with-additional-frontend-info)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |
| dex       | String | false    | Perp dex name. Defaults to empty string.       |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.frontend_open_orders(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function frontend_open_orders(client::HyperliquidClient, query::FrontendOpenOrdersQuery)
    return APIsRequest{FrontendOpenOrdersData}("POST", "info", query)(client)
end

function frontend_open_orders(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return frontend_open_orders(client, FrontendOpenOrdersQuery(; kw...))
end

end

