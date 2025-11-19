module PerpDexStatus

export PerpDexStatusQuery,
    PerpDexStatusData,
    perp_dex_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct PerpDexStatusQuery <: HyperliquidPublicQuery
    type::String
    dex::String
    
    function PerpDexStatusQuery(; dex::String)
        new("perpDexStatus", dex)
    end
end

struct PerpDexStatusData <: HyperliquidData
    totalNetDeposit::String
end

"""
    perp_dex_status(client::HyperliquidClient, query::PerpDexStatusQuery)
    perp_dex_status(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Get Perp Market Status.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#get-perp-market-status)

## Parameters:

| Parameter | Type   | Required | Description                                                            |
|:----------|:-------|:---------|:-----------------------------------------------------------------------|
| dex       | String | true     | Perp dex name. Empty string represents the first perp dex.             |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.perp_dex_status(;
    dex = ""
)
```
"""
function perp_dex_status(client::HyperliquidClient, query::PerpDexStatusQuery)
    return APIsRequest{PerpDexStatusData}("POST", "info", query)(client)
end

function perp_dex_status(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return perp_dex_status(client, PerpDexStatusQuery(; kw...))
end

end

