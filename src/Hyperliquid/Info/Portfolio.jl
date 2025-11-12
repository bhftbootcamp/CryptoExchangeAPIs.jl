module Portfolio

export PortfolioQuery,
    PortfolioData,
    portfolio

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct PortfolioQuery <: HyperliquidPublicQuery
    type::String = "portfolio"
    user::String
end

struct PortfolioInfo <: HyperliquidData
    accountValueHistory::Vector{Tuple{NanoDate,String}}
    pnlHistory::Vector{Tuple{NanoDate,String}}
    vlm::String
end

const PortfolioData = Vector{Tuple{String,PortfolioInfo}}

"""
    portfolio(client::HyperliquidClient, query::PortfolioQuery)
    portfolio(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query a user's portfolio.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-a-users-portfolio)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.portfolio(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function portfolio(client::HyperliquidClient, query::PortfolioQuery)
    return APIsRequest{PortfolioData}("POST", "info", query)(client)
end

function portfolio(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return portfolio(client, PortfolioQuery(; kw...))
end

end

