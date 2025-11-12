module FundingHistory

export FundingHistoryQuery,
    FundingHistoryData,
    FundingRate,
    funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingHistoryQuery <: HyperliquidPublicQuery
    type::String = "fundingHistory"
    coin::String
    startTime::Int
    endTime::Maybe{Int} = nothing
end

struct FundingRate <: HyperliquidData
    coin::String
    fundingRate::String
    premium::String
    time::NanoDate
end

const FundingHistoryData = Vector{FundingRate}

"""
    funding_history(client::HyperliquidClient, query::FundingHistoryQuery)
    funding_history(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve historical funding rates.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-historical-funding-rates)

## Parameters:

| Parameter | Type   | Required | Description                                      |
|:----------|:-------|:---------|:-------------------------------------------------|
| coin      | String | true     | Coin name (e.g. "ETH")                           |
| startTime | Int    | true     | Start time in milliseconds, inclusive            |
| endTime   | Int    | false    | End time in milliseconds, inclusive              |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.funding_history(;
    coin = "ETH",
    startTime = 1683849600076
)
```
"""
function funding_history(client::HyperliquidClient, query::FundingHistoryQuery)
    return APIsRequest{FundingHistoryData}("POST", "info", query)(client)
end

function funding_history(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return funding_history(client, FundingHistoryQuery(; kw...))
end

end

