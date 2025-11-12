module DelegatorHistory

export DelegatorHistoryQuery,
    DelegatorHistoryData,
    DelegatorHistoryEntry,
    delegator_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DelegatorHistoryQuery <: HyperliquidPublicQuery
    type::String = "delegatorHistory"
    user::String
end

struct DelegatorHistoryEntry <: HyperliquidData
    time::NanoDate
    hash::String
    delta::Dict{String,Any}
end

const DelegatorHistoryData = Vector{DelegatorHistoryEntry}

"""
    delegator_history(client::HyperliquidClient, query::DelegatorHistoryQuery)
    delegator_history(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's staking history.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-staking-history)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.delegator_history(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function delegator_history(client::HyperliquidClient, query::DelegatorHistoryQuery)
    return APIsRequest{DelegatorHistoryData}("POST", "info", query)(client)
end

function delegator_history(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return delegator_history(client, DelegatorHistoryQuery(; kw...))
end

end

