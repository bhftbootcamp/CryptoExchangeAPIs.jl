module PerpDexs

export PerpDexsQuery,
    PerpDexsData,
    perp_dexs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct PerpDexsQuery <: HyperliquidPublicQuery
    type::String
    
    function PerpDexsQuery()
        new("perpDexs")
    end
end

#Response is heterogeneous array with nulls and objects - just wrap the raw parsed JSON
struct PerpDexsData <: HyperliquidData
    items::Vector{Any}
    
    # Constructor that accepts the raw parsed array directly
    PerpDexsData(items::Vector) = new(items)
end

# Tell Serde to deserialize the top-level array directly into our wrapper
function Serde.deser(::Serde.CustomType, ::Type{PerpDexsData}, x::Vector)
    return PerpDexsData(x)
end

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

