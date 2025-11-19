module MetaAndAssetCtxs

export MetaAndAssetCtxsQuery,
    MetaAndAssetCtxsData,
    meta_and_asset_ctxs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct MetaAndAssetCtxsQuery <: HyperliquidPublicQuery
    type::String
    
    function MetaAndAssetCtxsQuery()
        new("metaAndAssetCtxs")
    end
end

struct AssetInfo <: HyperliquidData
    name::String
    szDecimals::Int
    maxLeverage::Int
    onlyIsolated::Maybe{Bool}
end

struct UniverseData <: HyperliquidData
    universe::Vector{AssetInfo}
end

struct AssetContext <: HyperliquidData
    dayNtlVlm::String
    funding::String
    impactPxs::Maybe{Vector{String}}
    markPx::String
    midPx::Maybe{String}
    openInterest::String
    oraclePx::String
    premium::Maybe{String}
    prevDayPx::String
end

const MetaAndAssetCtxsData = Tuple{UniverseData, Vector{AssetContext}}

"""
    meta_and_asset_ctxs(client::HyperliquidClient, query::MetaAndAssetCtxsQuery)
    meta_and_asset_ctxs(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve perpetuals asset contexts (includes mark price, current funding, open interest, etc.).

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-perpetuals-asset-contexts-includes-mark-price-current-funding-open-interest-etc.)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.meta_and_asset_ctxs()
```
"""
function meta_and_asset_ctxs(client::HyperliquidClient, query::MetaAndAssetCtxsQuery)
    return APIsRequest{MetaAndAssetCtxsData}("POST", "info", query)(client)
end

function meta_and_asset_ctxs(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return meta_and_asset_ctxs(client, MetaAndAssetCtxsQuery(; kw...))
end

end

