module Referral

export ReferralQuery,
    ReferralData,
    referral

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ReferralQuery <: HyperliquidPublicQuery
    type::String = "referral"
    user::String
end

struct ReferredBy <: HyperliquidData
    referrer::String
    code::String
end

struct ReferralState <: HyperliquidData
    cumVlm::String
    cumRewardedFeesSinceReferred::String
    cumFeesRewardedToReferrer::String
    timeJoined::NanoDate
    user::String
end

struct ReferrerStateData <: HyperliquidData
    stage::String
    data::Dict{String,Any}
end

struct TokenState <: HyperliquidData
    cumVlm::String
    unclaimedRewards::String
    claimedRewards::String
    builderRewards::String
end

struct ReferralData <: HyperliquidData
    referredBy::Maybe{ReferredBy}
    cumVlm::String
    unclaimedRewards::String
    claimedRewards::String
    builderRewards::String
    tokenToState::Vector{Tuple{Int,TokenState}}
    referrerState::Maybe{ReferrerStateData}
    rewardHistory::Vector{Any}
end

"""
    referral(client::HyperliquidClient, query::ReferralQuery)
    referral(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's referral information.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-referral-information)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.referral(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function referral(client::HyperliquidClient, query::ReferralQuery)
    return APIsRequest{ReferralData}("POST", "info", query)(client)
end

function referral(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return referral(client, ReferralQuery(; kw...))
end

end

