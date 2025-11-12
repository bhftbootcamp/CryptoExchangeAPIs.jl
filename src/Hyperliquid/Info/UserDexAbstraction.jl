module UserDexAbstraction

export UserDexAbstractionQuery,
    UserDexAbstractionData,
    user_dex_abstraction

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserDexAbstractionQuery <: HyperliquidPublicQuery
    type::String = "userDexAbstraction"
    user::String
end

const UserDexAbstractionData = Bool

"""
    user_dex_abstraction(client::HyperliquidClient, query::UserDexAbstractionQuery)
    user_dex_abstraction(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's HIP-3 DEX abstraction state.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-hip-3-dex-abstraction-state)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_dex_abstraction(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_dex_abstraction(client::HyperliquidClient, query::UserDexAbstractionQuery)
    return APIsRequest{UserDexAbstractionData}("POST", "info", query)(client)
end

function user_dex_abstraction(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_dex_abstraction(client, UserDexAbstractionQuery(; kw...))
end

end

