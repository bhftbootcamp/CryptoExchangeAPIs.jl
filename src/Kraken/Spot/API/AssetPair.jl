module AssetPair

export AssetPairQuery,
    AssetPairInfoData,
    AssetPairFeeData,
    AssetPairLeverageData,
    asset_pair

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum AssetPairInfo info leverage fees

Base.@kwdef struct AssetPairQuery <: KrakenPublicQuery
    pair::Maybe{String} = nothing
    info::AssetPairInfo = info
end

struct Fee <: KrakenData
    volume::Int64
    percent::Float64
end

struct AssetPairInfoData <: KrakenData
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
    status::String
    tick_size::Maybe{Float64}
    wsname::String
end

struct AssetPairFeeData <: KrakenData
    fee_volume_currency::String
    fees::Vector{Fee}
    fees_maker::Vector{Fee}
end

struct AssetPairLeverageData <: KrakenData
    leverage_buy::Vector{Int64}
    leverage_sell::Vector{Int64}
end

"""
    asset_pair(client::KrakenClient, query::AssetPairQuery)
    asset_pair(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get tradable asset pairs.

[`GET 0/public/AssetPairs`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getTradableAssetPairs)

## Parameters:

| Parameter | Type          | Required | Description                                    |
|:----------|:--------------|:---------|:-----------------------------------------------|
| pair      | String        | false    |                                                |
| info      | AssetPairInfo | false    | Default: `info`, Available: `leverage`, `fees` |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kraken

result = Kraken.Spot.asset_pair(;
    pair = "ACAUSD"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "ACAUSD":{
      "altname":"ACAUSD",
      "base":"ACA",
      "quote":"ZUSD",
      "aclass_base":"currency",
      "aclass_quote":"currency",
      "cost_decimals":5,
      "costmin":0.5,
      "fee_volume_currency":"ZUSD",
      "fees":[
        {
          "volume":0,
          "percent":0.4
        },
        ...
      ],
      "fees_maker":[
        {
          "volume":0,
          "percent":0.25
        },
        ...
      ],
      "leverage_buy":[],
      "leverage_sell":[],
      "lot":"unit",
      "lot_decimals":8,
      "lot_multiplier":1,
      "margin_call":80,
      "margin_stop":40,
      "ordermin":40.0,
      "pair_decimals":3,
      "status":"online",
      "tick_size":0.001,
      "wsname":"ACA/USD"
    }
  }
}
```
"""
function asset_pair(client::KrakenClient, query::AssetPairQuery)
    T = if query.info == info
        Dict{String,AssetPairInfoData}
    elseif query.info == fees
        Dict{String,AssetPairFeeData}
    elseif query.info == leverage
        Dict{String,AssetPairLeverageData}
    end
    return APIsRequest{Data{T}}("GET", "0/public/AssetPairs", query)(client)
end

function asset_pair(client::KrakenClient = Kraken.Spot.public_client; kw...)
    return asset_pair(client, AssetPairQuery(; kw...))
end

end
