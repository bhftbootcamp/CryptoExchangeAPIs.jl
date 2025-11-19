module PerpDeployAuctionStatus

export PerpDeployAuctionStatusQuery,
    PerpDeployAuctionStatusData,
    perp_deploy_auction_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct PerpDeployAuctionStatusQuery <: HyperliquidPublicQuery
    type::String
    
    function PerpDeployAuctionStatusQuery()
        new("perpDeployAuctionStatus")
    end
end

struct PerpDeployAuctionStatusData <: HyperliquidData
    startTimeSeconds::Int
    durationSeconds::Int
    startGas::String
    currentGas::String
    endGas::Maybe{String}
end

"""
    perp_deploy_auction_status(client::HyperliquidClient, query::PerpDeployAuctionStatusQuery)
    perp_deploy_auction_status(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve information about the Perp Deploy Auction.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-information-about-the-perp-deploy-auction)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.perp_deploy_auction_status()
```
"""
function perp_deploy_auction_status(client::HyperliquidClient, query::PerpDeployAuctionStatusQuery)
    return APIsRequest{PerpDeployAuctionStatusData}("POST", "info", query)(client)
end

function perp_deploy_auction_status(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return perp_deploy_auction_status(client, PerpDeployAuctionStatusQuery(; kw...))
end

end

