module FundingHistory

export FundingHistoryQuery,
    FundingHistoryData,
    funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct FundingHistoryQuery <: HyperliquidPublicQuery
    type::String
    coin::String
    startTime::DateTime
    endTime::Maybe{DateTime}

    function FundingHistoryQuery(;
        coin::String,
        startTime::DateTime,
        endTime::Maybe{DateTime} = nothing,
    )
        new("fundingHistory", coin, startTime, endTime)
    end
end

struct FundingHistoryData <: HyperliquidData
    coin::String
    fundingRate::Float64
    premium::Float64
    time::NanoDate
end

"""
    funding_history(client::HyperliquidClient, query::FundingHistoryQuery)
    funding_history(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve historical funding rates for a perpetual coin.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-historical-funding-rates)

## Parameters:

| Parameter | Type     | Required | Description                                       |
|:----------|:---------|:---------|:--------------------------------------------------|
| coin      | String   | true     | Coin name (e.g. BTC, ETH).                        |
| startTime | DateTime | true     | Start time (sent as milliseconds).                |
| endTime   | DateTime | false    | End time (sent as milliseconds). Defaults to now. |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.funding_history(;
    coin = "BTC",
    startTime = DateTime("2024-01-01T00:00:00"),
)

result = Hyperliquid.Info.funding_history(;
    coin = "ETH",
    startTime = DateTime("2024-01-01T00:00:00"),
    endTime = DateTime("2024-02-01T00:00:00"),
)
```
"""
function funding_history(client::HyperliquidClient, query::FundingHistoryQuery)
    return APIsRequest{Vector{FundingHistoryData}}("POST", "info", query)(client)
end

function funding_history(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return funding_history(client, FundingHistoryQuery(; kw...))
end

end
