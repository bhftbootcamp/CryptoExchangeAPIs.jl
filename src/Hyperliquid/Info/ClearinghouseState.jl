module ClearinghouseState

export ClearinghouseStateQuery,
    ClearinghouseStateData,
    clearinghouse_state

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ClearinghouseStateQuery <: HyperliquidPublicQuery
    type::String = "clearinghouseState"
    user::String
    dex::Maybe{String} = nothing
end

struct LeverageInfo <: HyperliquidData
    type::String
    value::Int
    rawUsd::Maybe{String}
end

struct CumFunding <: HyperliquidData
    allTime::String
    sinceChange::String
    sinceOpen::String
end

struct PositionInfo <: HyperliquidData
    coin::String
    cumFunding::CumFunding
    entryPx::String
    leverage::LeverageInfo
    liquidationPx::String
    marginUsed::String
    maxLeverage::Int
    positionValue::String
    returnOnEquity::String
    szi::String
    unrealizedPnl::String
end

struct AssetPosition <: HyperliquidData
    position::PositionInfo
    type::String
end

struct MarginSummary <: HyperliquidData
    accountValue::String
    totalMarginUsed::String
    totalNtlPos::String
    totalRawUsd::String
end

struct ClearinghouseStateData <: HyperliquidData
    assetPositions::Vector{AssetPosition}
    crossMaintenanceMarginUsed::String
    crossMarginSummary::MarginSummary
    marginSummary::MarginSummary
    time::NanoDate
    withdrawable::String
end

"""
    clearinghouse_state(client::HyperliquidClient, query::ClearinghouseStateQuery)
    clearinghouse_state(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve user's perpetuals account summary.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-users-perpetuals-account-summary)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |
| dex       | String | false    | Perp dex name. Defaults to empty string.       |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.clearinghouse_state(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function clearinghouse_state(client::HyperliquidClient, query::ClearinghouseStateQuery)
    return APIsRequest{ClearinghouseStateData}("POST", "info", query)(client)
end

function clearinghouse_state(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return clearinghouse_state(client, ClearinghouseStateQuery(; kw...))
end

end

