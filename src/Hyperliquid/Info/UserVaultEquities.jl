module UserVaultEquities

export UserVaultEquitiesQuery,
    UserVaultEquitiesData,
    VaultEquity,
    user_vault_equities

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserVaultEquitiesQuery <: HyperliquidPublicQuery
    type::String = "userVaultEquities"
    user::String
end

struct VaultEquity <: HyperliquidData
    vaultAddress::String
    equity::String
end

const UserVaultEquitiesData = Vector{VaultEquity}

"""
    user_vault_equities(client::HyperliquidClient, query::UserVaultEquitiesQuery)
    user_vault_equities(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's vault deposits.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-vault-deposits)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_vault_equities(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_vault_equities(client::HyperliquidClient, query::UserVaultEquitiesQuery)
    return APIsRequest{UserVaultEquitiesData}("POST", "info", query)(client)
end

function user_vault_equities(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_vault_equities(client, UserVaultEquitiesQuery(; kw...))
end

end

