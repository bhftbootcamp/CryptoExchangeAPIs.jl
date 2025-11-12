module UserFillsByTime

export UserFillsByTimeQuery,
    UserFillsByTimeData,
    user_fills_by_time

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserFillsByTimeQuery <: HyperliquidPublicQuery
    type::String = "userFillsByTime"
    user::String
    startTime::Int
    endTime::Maybe{Int} = nothing
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

const UserFillsByTimeData = Vector{FillData}

"""
    user_fills_by_time(client::HyperliquidClient, query::UserFillsByTimeQuery)
    user_fills_by_time(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve a user's fills by time. Returns at most 2000 fills per response.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-a-users-fills-by-time)

## Parameters:

| Parameter       | Type   | Required | Description                                      |
|:----------------|:-------|:---------|:-------------------------------------------------|
| user            | String | true     | Address in 42-character hexadecimal format       |
| startTime       | Int    | true     | Start time in milliseconds, inclusive            |
| endTime         | Int    | false    | End time in milliseconds, inclusive              |
| aggregateByTime | Bool   | false    | Aggregate partial fills                          |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_fills_by_time(;
    user = "0x0000000000000000000000000000000000000000",
    startTime = 1681222254710
)
```
"""
function user_fills_by_time(client::HyperliquidClient, query::UserFillsByTimeQuery)
    return APIsRequest{UserFillsByTimeData}("POST", "info", query)(client)
end

function user_fills_by_time(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_fills_by_time(client, UserFillsByTimeQuery(; kw...))
end

end

