module UserFills

export UserFillsQuery,
    UserFillsData,
    FillData,
    user_fills

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserFillsQuery <: HyperliquidPublicQuery
    type::String = "userFills"
    user::String
    aggregateByTime::Maybe{Bool} = nothing
end

struct FillData <: HyperliquidData
    coin::String
    px::String
    sz::String
    side::String
    time::NanoDate
    startPosition::String
    dir::String
    closedPnl::String
    hash::String
    oid::Int
    crossed::Bool
    fee::String
    tid::Int
    feeToken::String
    builderFee::Maybe{String}
end

const UserFillsData = Vector{FillData}

"""
    user_fills(client::HyperliquidClient, query::UserFillsQuery)
    user_fills(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's fills. Returns at most 2000 most recent fills.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-fills)

## Parameters:

| Parameter       | Type   | Required | Description                                    |
|:----------------|:-------|:---------|:-----------------------------------------------|
| user            | String | true     | Address in 42-character hexadecimal format     |
| aggregateByTime | Bool   | false    | Aggregate partial fills                        |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_fills(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_fills(client::HyperliquidClient, query::UserFillsQuery)
    return APIsRequest{UserFillsData}("POST", "info", query)(client)
end

function user_fills(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_fills(client, UserFillsQuery(; kw...))
end

end

