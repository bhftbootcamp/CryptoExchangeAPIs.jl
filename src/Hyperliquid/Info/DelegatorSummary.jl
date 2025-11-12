module DelegatorSummary

export DelegatorSummaryQuery,
    DelegatorSummaryData,
    delegator_summary

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DelegatorSummaryQuery <: HyperliquidPublicQuery
    type::String = "delegatorSummary"
    user::String
end

struct DelegatorSummaryData <: HyperliquidData
    delegated::String
    undelegated::String
    totalPendingWithdrawal::String
    nPendingWithdrawals::Int
end

"""
    delegator_summary(client::HyperliquidClient, query::DelegatorSummaryQuery)
    delegator_summary(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's staking summary.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-staking-summary)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.delegator_summary(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function delegator_summary(client::HyperliquidClient, query::DelegatorSummaryQuery)
    return APIsRequest{DelegatorSummaryData}("POST", "info", query)(client)
end

function delegator_summary(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return delegator_summary(client, DelegatorSummaryQuery(; kw...))
end

end

