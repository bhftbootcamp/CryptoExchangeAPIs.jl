module DelegatorRewards

export DelegatorRewardsQuery,
    DelegatorRewardsData,
    RewardEntry,
    delegator_rewards

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DelegatorRewardsQuery <: HyperliquidPublicQuery
    type::String = "delegatorRewards"
    user::String
end

struct RewardEntry <: HyperliquidData
    time::NanoDate
    source::String
    totalAmount::String
end

const DelegatorRewardsData = Vector{RewardEntry}

"""
    delegator_rewards(client::HyperliquidClient, query::DelegatorRewardsQuery)
    delegator_rewards(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's staking rewards.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-staking-rewards)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.delegator_rewards(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function delegator_rewards(client::HyperliquidClient, query::DelegatorRewardsQuery)
    return APIsRequest{DelegatorRewardsData}("POST", "info", query)(client)
end

function delegator_rewards(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return delegator_rewards(client, DelegatorRewardsQuery(; kw...))
end

end

