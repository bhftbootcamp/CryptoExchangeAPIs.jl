module PerpDexLimits

export PerpDexLimitsQuery,
    PerpDexLimitsData,
    perp_dex_limits

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct PerpDexLimitsQuery <: HyperliquidPublicQuery
    type::String
    dex::String
    
    function PerpDexLimitsQuery(; dex::String)
        new("perpDexLimits", dex)
    end
end

struct PerpDexLimitsData <: HyperliquidData
    totalOiCap::String
    oiSzCapPerPerp::String
    maxTransferNtl::String
    coinToOiCap::Vector{Tuple{String,String}}
end

"""
    perp_dex_limits(client::HyperliquidClient, query::PerpDexLimitsQuery)
    perp_dex_limits(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve Builder-Deployed Perp Market Limits.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-builder-deployed-perp-market-limits)

## Parameters:

| Parameter | Type   | Required | Description                                                |
|:----------|:-------|:---------|:-----------------------------------------------------------|
| dex       | String | true     | Perp dex name of builder-deployed dex market.              |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.perp_dex_limits(;
    dex = "test"
)
```
"""
function perp_dex_limits(client::HyperliquidClient, query::PerpDexLimitsQuery)
    return APIsRequest{PerpDexLimitsData}("POST", "info", query)(client)
end

function perp_dex_limits(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return perp_dex_limits(client, PerpDexLimitsQuery(; kw...))
end

end

