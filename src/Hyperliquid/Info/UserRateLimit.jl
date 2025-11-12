module UserRateLimit

export UserRateLimitQuery,
    UserRateLimitData,
    user_rate_limit

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct UserRateLimitQuery <: HyperliquidPublicQuery
    type::String = "userRateLimit"
    user::String
end

struct UserRateLimitData <: HyperliquidData
    cumVlm::String
    nRequestsUsed::Int
    nRequestsCap::Int
    nRequestsSurplus::Int
end

"""
    user_rate_limit(client::HyperliquidClient, query::UserRateLimitQuery)
    user_rate_limit(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query user rate limits.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-user-rate-limits)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.user_rate_limit(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function user_rate_limit(client::HyperliquidClient, query::UserRateLimitQuery)
    return APIsRequest{UserRateLimitData}("POST", "info", query)(client)
end

function user_rate_limit(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return user_rate_limit(client, UserRateLimitQuery(; kw...))
end

end

