module SpotPairDeployAuctionStatus

export SpotPairDeployAuctionStatusQuery,
    SpotPairDeployAuctionStatusData,
    spot_pair_deploy_auction_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct SpotPairDeployAuctionStatusQuery <: HyperliquidPublicQuery
    type::String
    
    function SpotPairDeployAuctionStatusQuery()
        new("spotPairDeployAuctionStatus")
    end
end

struct SpotPairDeployAuctionStatusData <: HyperliquidData
    startTimeSeconds::Int
    durationSeconds::Int
    startGas::String
    currentGas::String
    endGas::Maybe{String}
end

"""
    spot_pair_deploy_auction_status(client::HyperliquidClient, query::SpotPairDeployAuctionStatusQuery)
    spot_pair_deploy_auction_status(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve information about the Spot Pair Deploy Auction.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-information-about-the-spot-pair-deploy-auction)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.spot_pair_deploy_auction_status()
```
"""
function spot_pair_deploy_auction_status(client::HyperliquidClient, query::SpotPairDeployAuctionStatusQuery)
    return APIsRequest{SpotPairDeployAuctionStatusData}("POST", "info", query)(client)
end

function spot_pair_deploy_auction_status(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return spot_pair_deploy_auction_status(client, SpotPairDeployAuctionStatusQuery(; kw...))
end

end

