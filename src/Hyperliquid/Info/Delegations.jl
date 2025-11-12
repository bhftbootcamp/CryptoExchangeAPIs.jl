module Delegations

export DelegationsQuery,
    DelegationsData,
    DelegationInfo,
    delegations

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DelegationsQuery <: HyperliquidPublicQuery
    type::String = "delegations"
    user::String
end

struct DelegationInfo <: HyperliquidData
    validator::String
    amount::String
    lockedUntilTimestamp::NanoDate
end

const DelegationsData = Vector{DelegationInfo}

"""
    delegations(client::HyperliquidClient, query::DelegationsQuery)
    delegations(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's staking delegations.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-staking-delegations)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.delegations(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function delegations(client::HyperliquidClient, query::DelegationsQuery)
    return APIsRequest{DelegationsData}("POST", "info", query)(client)
end

function delegations(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return delegations(client, DelegationsQuery(; kw...))
end

end

