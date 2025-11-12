module SpotClearinghouseState

export SpotClearinghouseStateQuery,
    SpotClearinghouseStateData,
    spot_clearinghouse_state

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SpotClearinghouseStateQuery <: HyperliquidPublicQuery
    type::String = "spotClearinghouseState"
    user::String
end

struct TokenBalance <: HyperliquidData
    coin::String
    token::Int
    hold::String
    total::String
    entryNtl::String
end

struct SpotClearinghouseStateData <: HyperliquidData
    balances::Vector{TokenBalance}
end

"""
    spot_clearinghouse_state(client::HyperliquidClient, query::SpotClearinghouseStateQuery)
    spot_clearinghouse_state(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's token balances.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-a-users-token-balances)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.spot_clearinghouse_state(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function spot_clearinghouse_state(client::HyperliquidClient, query::SpotClearinghouseStateQuery)
    return APIsRequest{SpotClearinghouseStateData}("POST", "info", query)(client)
end

function spot_clearinghouse_state(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return spot_clearinghouse_state(client, SpotClearinghouseStateQuery(; kw...))
end

end

