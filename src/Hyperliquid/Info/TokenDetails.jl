module TokenDetails

export TokenDetailsQuery,
    TokenDetailsData,
    token_details

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct TokenDetailsQuery <: HyperliquidPublicQuery
    type::String
    tokenId::String
    
    function TokenDetailsQuery(; tokenId::String)
        new("tokenDetails", tokenId)
    end
end

struct GenesisInfo <: HyperliquidData
    userBalances::Vector{Tuple{String,String}}
    existingTokenBalances::Vector{Any}
end

struct TokenDetailsData <: HyperliquidData
    name::String
    maxSupply::String
    totalSupply::String
    circulatingSupply::String
    szDecimals::Int
    weiDecimals::Int
    midPx::String
    markPx::String
    prevDayPx::String
    genesis::Maybe{GenesisInfo}
    deployer::Maybe{String}
    deployGas::Maybe{String}
    deployTime::Maybe{String}
    seededUsdc::String
    nonCirculatingUserBalances::Vector{Any}
    futureEmissions::String
end

"""
    token_details(client::HyperliquidClient, query::TokenDetailsQuery)
    token_details(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve information about a token.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-information-about-a-token)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| tokenId   | String | true     | Token ID in 34-character hexadecimal format    |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.token_details(;
    tokenId = "0x00000000000000000000000000000000"
)
```
"""
function token_details(client::HyperliquidClient, query::TokenDetailsQuery)
    return APIsRequest{TokenDetailsData}("POST", "info", query)(client)
end

function token_details(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return token_details(client, TokenDetailsQuery(; kw...))
end

end

