module AllMids

export AllMidsQuery,
    AllMidsData,
    all_mids

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct AllMidsQuery <: HyperliquidPublicQuery
    type::String
    dex::Maybe{String}
    
    function AllMidsQuery(; dex::Maybe{String} = nothing)
        new("allMids", dex)
    end
end

# Response is a Dict{String, String} where keys are coin names and values are mid prices
const AllMidsData = Dict{String,String}

"""
    all_mids(client::HyperliquidClient, query::AllMidsQuery)
    all_mids(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve mids for all coins. If the book is empty, the last trade price will be used as a fallback.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#retrieve-mids-for-all-coins)

## Parameters:

| Parameter | Type   | Required | Description                                                           |
|:----------|:-------|:---------|:----------------------------------------------------------------------|
| dex       | String | false    | Perp dex name. Defaults to empty string (first perp dex).             |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.all_mids()
```

## Response:

```julia
Dict{String, String}(
    "BTC" => "50000.0",
    "ETH" => "3000.0"
)
```
"""
function all_mids(client::HyperliquidClient, query::AllMidsQuery)
    return APIsRequest{AllMidsData}("POST", "info", query)(client)
end

function all_mids(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return all_mids(client, AllMidsQuery(; kw...))
end

end

