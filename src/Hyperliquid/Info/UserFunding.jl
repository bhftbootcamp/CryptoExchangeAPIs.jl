module UserFunding

export UserFundingQuery,
    UserFundingData,
    FundingDelta,
    user_funding

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserFundingQuery <: HyperliquidPublicQuery
    type::String = "userFunding"
    user::String
    startTime::Int
    endTime::Maybe{Int} = nothing
end

struct FundingDelta <: HyperliquidData
    type::String
    coin::String
    fundingRate::String
    szi::String
    usdc::String
end

struct FundingEntry <: HyperliquidData
    delta::FundingDelta
    hash::String
    time::NanoDate
end

const UserFundingData = Vector{FundingEntry}

"""
    user_funding(client::HyperliquidClient, query::UserFundingQuery)
    user_funding(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's funding history.

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

result = Hyperliquid.Info.user_funding(;
    user = "0x0000000000000000000000000000000000000000",
    startTime = 1681222254710
)
```
"""
function user_funding(client::HyperliquidClient, query::UserFundingQuery)
    return APIsRequest{UserFundingData}("POST", "info", query)(client)
end

function user_funding(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_funding(client, UserFundingQuery(; kw...))
end

end

