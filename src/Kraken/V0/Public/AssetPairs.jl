module AssetPairs

export AssetPairsQuery,
    AssetPairsInfoData,
    AssetPairsFeeData,
    AssetPairsLeverageData,
    asset_pairs

export AssetPairInfo

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx AssetPairInfo info leverage fees

@enumx Status online cancel_only post_only limit_only reduce_only

Base.@kwdef struct AssetPairsQuery <: KrakenPublicQuery
    pair::Maybe{String} = nothing
    info::AssetPairInfo.T = AssetPairInfo.info
end

struct Fee <: KrakenData
    volume::Int64
    percent::Float64
end

struct AssetPairsInfoData <: KrakenData
    altname::String
    base::String
    var"quote"::String
    aclass_base::String
    aclass_quote::String
    cost_decimals::Int64
    costmin::Maybe{Float64}
    fee_volume_currency::String
    fees::Maybe{Vector{Fee}}
    fees_maker::Vector{Fee}
    leverage_buy::Vector{Int64}
    leverage_sell::Vector{Int64}
    lot::String
    lot_decimals::Int64
    lot_multiplier::Int64
    margin_call::Int64
    margin_stop::Int64
    ordermin::Maybe{Float64}
    pair_decimals::Int64
    status::Status.T
    tick_size::Maybe{Float64}
    wsname::String
end

struct AssetPairsFeeData <: KrakenData
    fee_volume_currency::String
    fees::Vector{Fee}
    fees_maker::Vector{Fee}
end

struct AssetPairsLeverageData <: KrakenData
    leverage_buy::Vector{Int64}
    leverage_sell::Vector{Int64}
end

"""
    asset_pairs(client::KrakenClient, query::AssetPairsQuery)
    asset_pairs(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)

Get tradable asset pairs.

[`GET 0/public/AssetPairs`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getTradableAssetPairs)

## Parameters:

| Parameter | Type          | Required | Description                                    |
|:----------|:--------------|:---------|:-----------------------------------------------|
| pair      | String        | false    |                                                |
| info      | AssetPairInfo | false    | Default: `info`, Available: `leverage`, `fees` |

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.V0.Public.asset_pairs(;
    pair = "ACAUSD"
)
```
"""
function asset_pairs(client::KrakenClient, query::AssetPairsQuery)
    T = if query.info == AssetPairInfo.info
        Dict{String,AssetPairsInfoData}
    elseif query.info == AssetPairInfo.fees
        Dict{String,AssetPairsFeeData}
    elseif query.info == AssetPairInfo.leverage
        Dict{String,AssetPairsLeverageData}
    end
    return APIsRequest{Data{T}}("GET", "0/public/AssetPairs", query)(client)
end

function asset_pairs(client::KrakenClient = Kraken.KrakenClient(Kraken.public_config); kw...)
    return asset_pairs(client, AssetPairsQuery(; kw...))
end

end

