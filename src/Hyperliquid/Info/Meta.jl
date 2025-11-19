module Meta

export MetaQuery,
    MetaData,
    meta

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct MetaQuery <: HyperliquidPublicQuery
    type::String
    dex::Maybe{String}
    
    function MetaQuery(; dex::Maybe{String} = nothing)
        new("meta", dex)
    end
end

struct AssetInfo <: HyperliquidData
    name::String
    szDecimals::Int
    maxLeverage::Int
    onlyIsolated::Maybe{Bool}
    isDelisted::Maybe{Bool}
    marginMode::Maybe{String}
end

struct MarginTier <: HyperliquidData
    lowerBound::String
    maxLeverage::Int
end

struct MarginTable <: HyperliquidData
    description::String
    marginTiers::Vector{MarginTier}
end

struct MarginTableEntry <: HyperliquidData
    id::Int
    table::MarginTable
end

function Serde.deser(::Serde.CustomType, ::Type{MarginTableEntry}, data::AbstractVector)
    length(data) == 2 || throw(ArgumentError("MarginTableEntry expects [id, table] tuple"))
    id = Serde.deser(Int, data[1])
    table = Serde.deser(MarginTable, data[2])
    return MarginTableEntry(id, table)
end

struct MetaData <: HyperliquidData
    universe::Vector{AssetInfo}
    marginTables::Vector{MarginTableEntry}
end

"""
    meta(client::HyperliquidClient, query::MetaQuery)
    meta(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve perpetuals metadata (universe and margin tables).

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-perpetuals-metadata-universe-and-margin-tables)

## Parameters:

| Parameter | Type   | Required | Description                                                           |
|:----------|:-------|:---------|:----------------------------------------------------------------------|
| dex       | String | false    | Perp dex name. Defaults to empty string (first perp dex).             |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.meta()
```
"""
function meta(client::HyperliquidClient, query::MetaQuery)
    return APIsRequest{MetaData}("POST", "info", query)(client)
end

function meta(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return meta(client, MetaQuery(; kw...))
end

end
