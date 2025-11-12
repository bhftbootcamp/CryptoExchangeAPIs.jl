module VaultDetails

export VaultDetailsQuery,
    VaultDetailsData,
    vault_details

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct VaultDetailsQuery <: HyperliquidPublicQuery
    type::String = "vaultDetails"
    vaultAddress::String
    user::Maybe{String} = nothing
end

struct PortfolioInfo <: HyperliquidData
    accountValueHistory::Vector{Tuple{NanoDate,String}}
    pnlHistory::Vector{Tuple{NanoDate,String}}
    vlm::String
end

struct FollowerInfo <: HyperliquidData
    user::String
    vaultEquity::String
    pnl::String
    allTimePnl::String
    daysFollowing::Int
    vaultEntryTime::NanoDate
    lockupUntil::NanoDate
end

struct RelationshipData <: HyperliquidData
    type::String
    data::Dict{String,Any}
end

struct VaultDetailsData <: HyperliquidData
    name::String
    vaultAddress::String
    leader::String
    description::String
    portfolio::Vector{Tuple{String,PortfolioInfo}}
    apr::Float64
    followerState::Maybe{Any}
    leaderFraction::Float64
    leaderCommission::Float64
    followers::Vector{FollowerInfo}
    maxDistributable::Float64
    maxWithdrawable::Float64
    isClosed::Bool
    relationship::RelationshipData
    allowDeposits::Bool
    alwaysCloseOnWithdraw::Bool
end

"""
    vault_details(client::HyperliquidClient, query::VaultDetailsQuery)
    vault_details(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve details for a vault.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-details-for-a-vault)

## Parameters:

| Parameter    | Type   | Required | Description                                    |
|:-------------|:-------|:---------|:-----------------------------------------------|
| vaultAddress | String | true     | Address in 42-character hexadecimal format     |
| user         | String | false    | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.vault_details(;
    vaultAddress = "0x0000000000000000000000000000000000000000"
)
```
"""
function vault_details(client::HyperliquidClient, query::VaultDetailsQuery)
    return APIsRequest{VaultDetailsData}("POST", "info", query)(client)
end

function vault_details(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return vault_details(client, VaultDetailsQuery(; kw...))
end

end

