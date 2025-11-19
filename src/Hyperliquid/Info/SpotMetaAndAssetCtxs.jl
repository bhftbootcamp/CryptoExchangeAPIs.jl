module SpotMetaAndAssetCtxs

export SpotMetaAndAssetCtxsQuery,
    SpotMetaAndAssetCtxsData,
    spot_meta_and_asset_ctxs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct SpotMetaAndAssetCtxsQuery <: HyperliquidPublicQuery
    type::String
    
    function SpotMetaAndAssetCtxsQuery()
        new("spotMetaAndAssetCtxs")
    end
end

struct EvmContract <: HyperliquidData
    address::String
    evm_extra_wei_decimals::Maybe{Int}
end

struct TokenInfo <: HyperliquidData
    name::String
    szDecimals::Int
    weiDecimals::Int
    index::Int
    tokenId::String
    isCanonical::Bool
    evmContract::Maybe{EvmContract}
    fullName::Maybe{String}
end

struct SpotPairInfo <: HyperliquidData
    name::String
    tokens::Vector{Int}
    index::Int
    isCanonical::Bool
end

struct SpotMetaInfo <: HyperliquidData
    tokens::Vector{TokenInfo}
    universe::Vector{SpotPairInfo}
end

struct SpotAssetContext <: HyperliquidData
    dayNtlVlm::String
    markPx::String
    midPx::Maybe{String}
    prevDayPx::String
end

const SpotMetaAndAssetCtxsData = Tuple{SpotMetaInfo, Vector{SpotAssetContext}}

"""
    spot_meta_and_asset_ctxs(client::HyperliquidClient, query::SpotMetaAndAssetCtxsQuery)
    spot_meta_and_asset_ctxs(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve spot asset contexts.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-spot-asset-contexts)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.spot_meta_and_asset_ctxs()
```
"""
function spot_meta_and_asset_ctxs(client::HyperliquidClient, query::SpotMetaAndAssetCtxsQuery)
    return APIsRequest{SpotMetaAndAssetCtxsData}("POST", "info", query)(client)
end

function spot_meta_and_asset_ctxs(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return spot_meta_and_asset_ctxs(client, SpotMetaAndAssetCtxsQuery(; kw...))
end

end

