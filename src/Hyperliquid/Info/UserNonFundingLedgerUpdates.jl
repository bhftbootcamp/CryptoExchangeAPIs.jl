module UserNonFundingLedgerUpdates

export UserNonFundingLedgerUpdatesQuery,
    UserNonFundingLedgerUpdatesData,
    user_non_funding_ledger_updates

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserNonFundingLedgerUpdatesQuery <: HyperliquidPublicQuery
    type::String = "userNonFundingLedgerUpdates"
    user::String
    startTime::Int
    endTime::Maybe{Int} = nothing
end

struct LedgerEntry <: HyperliquidData
    delta::Dict{String,Any}
    hash::String
    time::NanoDate
end

const UserNonFundingLedgerUpdatesData = Vector{LedgerEntry}

"""
    user_non_funding_ledger_updates(client::HyperliquidClient, query::UserNonFundingLedgerUpdatesQuery)
    user_non_funding_ledger_updates(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's non-funding ledger updates (deposits, transfers, withdrawals).

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-a-users-funding-history-or-non-funding-ledger-updates)

## Parameters:

| Parameter | Type   | Required | Description                                      |
|:----------|:-------|:---------|:-------------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format       |
| startTime | Int    | true     | Start time in milliseconds, inclusive            |
| endTime   | Int    | false    | End time in milliseconds, inclusive              |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_non_funding_ledger_updates(;
    user = "0x0000000000000000000000000000000000000000",
    startTime = 1681222254710
)
```
"""
function user_non_funding_ledger_updates(client::HyperliquidClient, query::UserNonFundingLedgerUpdatesQuery)
    return APIsRequest{UserNonFundingLedgerUpdatesData}("POST", "info", query)(client)
end

function user_non_funding_ledger_updates(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_non_funding_ledger_updates(client, UserNonFundingLedgerUpdatesQuery(; kw...))
end

end

