module SpotMeta

export SpotMetaQuery,
    SpotMetaData,
    spot_meta

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct SpotMetaQuery <: HyperliquidPublicQuery
    type::String
    
    function SpotMetaQuery()
        new("spotMeta")
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

struct SpotMetaData <: HyperliquidData
    tokens::Vector{TokenInfo}
    universe::Vector{SpotPairInfo}
end

"""
    spot_meta(client::HyperliquidClient, query::SpotMetaQuery)
    spot_meta(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve spot metadata.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-spot-metadata)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.spot_meta()
```
"""
function spot_meta(client::HyperliquidClient, query::SpotMetaQuery)
    return APIsRequest{SpotMetaData}("POST", "info", query)(client)
end

function spot_meta(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return spot_meta(client, SpotMetaQuery(; kw...))
end

end

