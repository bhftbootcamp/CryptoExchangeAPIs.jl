module OpenOrders

export OpenOrdersQuery,
    OpenOrdersData,
    OrderData,
    open_orders

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct OpenOrdersQuery <: HyperliquidPublicQuery
    type::String = "openOrders"
    user::String
    dex::Maybe{String} = nothing
end

struct OrderData <: HyperliquidData
    coin::String
    limitPx::String
    oid::Int
    side::String
    sz::String
    timestamp::NanoDate
end

const OpenOrdersData = Vector{OrderData}

"""
    open_orders(client::HyperliquidClient, query::OpenOrdersQuery)
    open_orders(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's open orders.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-open-orders)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |
| dex       | String | false    | Perp dex name. Defaults to empty string.       |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.open_orders(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function open_orders(client::HyperliquidClient, query::OpenOrdersQuery)
    return APIsRequest{OpenOrdersData}("POST", "info", query)(client)
end

function open_orders(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return open_orders(client, OpenOrdersQuery(; kw...))
end

end

