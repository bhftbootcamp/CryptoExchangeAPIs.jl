module UserFees

export UserFeesQuery,
    UserFeesData,
    user_fees

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserFeesQuery <: HyperliquidPublicQuery
    type::String = "userFees"
    user::String
end

struct DailyVlm <: HyperliquidData
    date::String
    userCross::String
    userAdd::String
    exchange::String
end

struct TierInfo <: HyperliquidData
    ntlCutoff::Maybe{String}
    makerFractionCutoff::Maybe{String}
    cross::Maybe{String}
    add::Maybe{String}
    spotCross::Maybe{String}
    spotAdd::Maybe{String}
end

struct FeeScheduleTiers <: HyperliquidData
    vip::Vector{TierInfo}
    mm::Vector{TierInfo}
end

struct FeeSchedule <: HyperliquidData
    cross::String
    add::String
    spotCross::String
    spotAdd::String
    tiers::FeeScheduleTiers
    referralDiscount::String
    stakingDiscountTiers::Vector{Dict{String,Any}}
end

struct StakingLink <: HyperliquidData
    type::String
    stakingUser::String
end

struct ActiveStakingDiscount <: HyperliquidData
    bpsOfMaxSupply::String
    discount::String
end

struct UserFeesData <: HyperliquidData
    dailyUserVlm::Vector{DailyVlm}
    feeSchedule::FeeSchedule
    userCrossRate::String
    userAddRate::String
    userSpotCrossRate::String
    userSpotAddRate::String
    activeReferralDiscount::String
    trial::Maybe{Any}
    feeTrialReward::String
    nextTrialAvailableTimestamp::Maybe{NanoDate}
    stakingLink::Maybe{StakingLink}
    activeStakingDiscount::Maybe{ActiveStakingDiscount}
end

"""
    user_fees(client::HyperliquidClient, query::UserFeesQuery)
    user_fees(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's fees.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-fees)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_fees(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_fees(client::HyperliquidClient, query::UserFeesQuery)
    return APIsRequest{UserFeesData}("POST", "info", query)(client)
end

function user_fees(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_fees(client, UserFeesQuery(; kw...))
end

end

