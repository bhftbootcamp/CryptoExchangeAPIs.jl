module SpotDeployState

export SpotDeployStateQuery,
    SpotDeployStateData,
    spot_deploy_state

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct SpotDeployStateQuery <: HyperliquidPublicQuery
    type::String
    user::String
    
    function SpotDeployStateQuery(; user::String)
        new("spotDeployState", user)
    end
end

struct TokenSpec <: HyperliquidData
    name::String
    szDecimals::Int
    weiDecimals::Int
end

struct DeployState <: HyperliquidData
    token::Int
    spec::TokenSpec
    fullName::String
    spots::Vector{Int}
    maxSupply::Int
    hyperliquidityGenesisBalance::String
    totalGenesisBalanceWei::String
    userGenesisBalances::Vector{Tuple{String,String}}
    existingTokenGenesisBalances::Vector{Tuple{Int,String}}
end

struct GasAuction <: HyperliquidData
    startTimeSeconds::Int
    durationSeconds::Int
    startGas::String
    currentGas::Maybe{String}
    endGas::String
end

struct SpotDeployStateData <: HyperliquidData
    states::Vector{DeployState}
    gasAuction::GasAuction
end

"""
    spot_deploy_state(client::HyperliquidClient, query::SpotDeployStateQuery)
    spot_deploy_state(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve information about the Spot Deploy Auction.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot#retrieve-information-about-the-spot-deploy-auction)

## Parameters:

| Parameter | Type   | Required | Description                                 |
|:----------|:-------|:---------|:--------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format  |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.spot_deploy_state(;
    user = "0x0000000000000000000000000000000000000000"
)
```
"""
function spot_deploy_state(client::HyperliquidClient, query::SpotDeployStateQuery)
    return APIsRequest{SpotDeployStateData}("POST", "info", query)(client)
end

function spot_deploy_state(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return spot_deploy_state(client, SpotDeployStateQuery(; kw...))
end

end

