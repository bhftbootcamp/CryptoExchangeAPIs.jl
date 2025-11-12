module UserRole

export UserRoleQuery,
    UserRoleData,
    user_role

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserRoleQuery <: HyperliquidPublicQuery
    type::String = "userRole"
    user::String
end

# Response structure varies based on role type
struct UserRoleData <: HyperliquidData
    role::String
    data::Maybe{Dict{String,Any}}
end

"""
    user_role(client::HyperliquidClient, query::UserRoleQuery)
    user_role(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's role.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-role)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_role(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_role(client::HyperliquidClient, query::UserRoleQuery)
    return APIsRequest{UserRoleData}("POST", "info", query)(client)
end

function user_role(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_role(client, UserRoleQuery(; kw...))
end

end

