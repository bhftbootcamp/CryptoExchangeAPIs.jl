module UserTwapSliceFills

export UserTwapSliceFillsQuery,
    UserTwapSliceFillsData,
    TwapSliceFill,
    user_twap_slice_fills

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserTwapSliceFillsQuery <: HyperliquidPublicQuery
    type::String = "userTwapSliceFills"
    user::String
end

struct FillInfo <: HyperliquidData
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
end

struct TwapSliceFill <: HyperliquidData
    fill::FillInfo
    twapId::Int
end

const UserTwapSliceFillsData = Vector{TwapSliceFill}

"""
    user_twap_slice_fills(client::HyperliquidClient, query::UserTwapSliceFillsQuery)
    user_twap_slice_fills(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's TWAP slice fills. Returns at most 2000 most recent TWAP slice fills.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-twap-slice-fills)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_twap_slice_fills(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_twap_slice_fills(client::HyperliquidClient, query::UserTwapSliceFillsQuery)
    return APIsRequest{UserTwapSliceFillsData}("POST", "info", query)(client)
end

function user_twap_slice_fills(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_twap_slice_fills(client, UserTwapSliceFillsQuery(; kw...))
end

end

