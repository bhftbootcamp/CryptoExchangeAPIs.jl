module PerpDexs

export PerpDexsQuery,
    PerpDexsData,
    perp_dexs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct PerpDexsQuery <: HyperliquidPublicQuery
    type::String = "perpDexs"
end

struct PerpDex <: HyperliquidData
    name::String
    fullName::String
    deployer::String
    oracleUpdater::Maybe{String}
    feeRecipient::Maybe{String}
    assetToStreamingOiCap::Vector{Tuple{String,String}}
end

const PerpDexsData = Vector{Maybe{PerpDex}}

"""
    perp_dexs(client::HyperliquidClient, query::PerpDexsQuery)
    perp_dexs(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve all perpetual dexs.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-all-perpetual-dexs)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.perp_dexs()
```
"""
function perp_dexs(client::HyperliquidClient, query::PerpDexsQuery)
    return APIsRequest{PerpDexsData}("POST", "info", query)(client)
end

function perp_dexs(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return perp_dexs(client, PerpDexsQuery(; kw...))
end

end

