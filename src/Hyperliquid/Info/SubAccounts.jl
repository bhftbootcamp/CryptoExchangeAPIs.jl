module SubAccounts

export SubAccountsQuery,
    SubAccountsData,
    SubAccountInfo,
    sub_accounts

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SubAccountsQuery <: HyperliquidPublicQuery
    type::String = "subAccounts"
    user::String
end

struct MarginSummary <: HyperliquidData
    accountValue::String
    totalNtlPos::String
    totalRawUsd::String
    totalMarginUsed::String
end

struct ClearinghouseInfo <: HyperliquidData
    marginSummary::MarginSummary
    crossMarginSummary::MarginSummary
    crossMaintenanceMarginUsed::String
    withdrawable::String
    assetPositions::Vector{Any}
    time::NanoDate
end

struct TokenBalance <: HyperliquidData
    coin::String
    token::Int
    total::String
    hold::String
    entryNtl::String
end

struct SpotStateInfo <: HyperliquidData
    balances::Vector{TokenBalance}
end

struct SubAccountInfo <: HyperliquidData
    name::String
    subAccountUser::String
    master::String
    clearinghouseState::ClearinghouseInfo
    spotState::SpotStateInfo
end

const SubAccountsData = Vector{SubAccountInfo}

"""
    sub_accounts(client::HyperliquidClient, query::SubAccountsQuery)
    sub_accounts(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's subaccounts.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-subaccounts)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.sub_accounts(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function sub_accounts(client::HyperliquidClient, query::SubAccountsQuery)
    return APIsRequest{SubAccountsData}("POST", "info", query)(client)
end

function sub_accounts(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return sub_accounts(client, SubAccountsQuery(; kw...))
end

end

