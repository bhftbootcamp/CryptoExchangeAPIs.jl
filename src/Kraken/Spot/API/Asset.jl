module Asset

export AssetQuery,
    AssetData,
    asset

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct AssetQuery <: KrakenPublicQuery
    asset::Maybe{Vector{String}} = nothing
    aclass::Maybe{String} = nothing
end

@enum AssetStatus begin
    enabled
    deposit_only
    withdrawal_only
    funding_temporarily_disabled
end

struct AssetData <: KrakenData
    aclass::String
    altname::String
    decimals::Int64
    display_decimals::Int64
    collateral_value::Maybe{Float64}
    status::AssetStatus
end

function Serde.SerQuery.ser_type(::Type{AssetQuery}, x::Vector{String})::String
    return join(x, ",")
end

function Serde.deser(::Type{AssetData}, ::Type{AssetStatus}, x::String)::AssetStatus
    x == "enabled"                      && return enabled
    x == "deposit_only"                 && return deposit_only
    x == "withdrawal_only"              && return withdrawal_only
    x == "funding_temporarily_disabled" && return funding_temporarily_disabled
    nothing
end

"""
    asset(client::KrakenClient, query::AssetQuery)
    asset(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get information about the assets that are available for deposit, withdrawal, trading and earn.

[`GET 0/public/Assets`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getAssetInfo)

## Parameters:

| Parameter | Type           | Required | Description |
|:----------|:---------------|:---------|:------------|
| asset     | Vector{String} | false    |             |
| aclass    | String         | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kraken

result = Kraken.Spot.asset(;
    asset = ["ADA", "SUSHI"],
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "ADA":{
      "aclass":"currency",
      "altname":"ADA",
      "decimals":8,
      "display_decimals":6,
      "collateral_value":0.9,
      "status":"enabled"
    },
    "SUSHI":{
      "aclass":"currency",
      "altname":"SUSHI",
      "decimals":10,
      "display_decimals":5,
      "collateral_value":null,
      "status":"enabled"
    }
  }
}
```
"""
function asset(client::KrakenClient, query::AssetQuery)
    return APIsRequest{Data{Dict{String,AssetData}}}("GET", "0/public/Assets", query)(client)
end

function asset(client::KrakenClient = Kraken.Spot.public_client; kw...)
    return asset(client, AssetQuery(; kw...))
end

end
