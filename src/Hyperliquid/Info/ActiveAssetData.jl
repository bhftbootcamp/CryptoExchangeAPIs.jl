module ActiveAssetData

export ActiveAssetDataQuery,
    ActiveAssetDataInfo,
    active_asset_data

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ActiveAssetDataQuery <: HyperliquidPublicQuery
    type::String = "activeAssetData"
    user::String
    coin::String
end

struct LeverageInfo <: HyperliquidData
    type::String
    value::Int
end

struct ActiveAssetDataInfo <: HyperliquidData
    user::String
    coin::String
    leverage::LeverageInfo
    maxTradeSzs::Vector{String}
    availableToTrade::Vector{String}
    markPx::String
end

"""
    active_asset_data(client::HyperliquidClient, query::ActiveAssetDataQuery)
    active_asset_data(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve User's Active Asset Data.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-users-active-asset-data)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |
| coin      | String | true     | Coin name                                      |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.active_asset_data(;
    user = "0x0000000000000000000000000000000000000000",
    coin = "BTC"
)
```
"""
function active_asset_data(client::HyperliquidClient, query::ActiveAssetDataQuery)
    return APIsRequest{ActiveAssetDataInfo}("POST", "info", query)(client)
end

function active_asset_data(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return active_asset_data(client, ActiveAssetDataQuery(; kw...))
end

end

