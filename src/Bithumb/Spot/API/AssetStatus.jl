module AssetStatus

export AssetStatusQuery,
    AssetStatusData,
    asset_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bithumb
using CryptoAPIs.Bithumb: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct AssetStatusQuery <: BithumbPublicQuery
    currency::Maybe{String} = "ALL"
end

Serde.SerQuery.ser_ignore_field(::Type{AssetStatusQuery}, ::Val{:currency}) = true

struct AssetStatusData <: BithumbData
    currency::String
    net_type::String
    deposit_status::Bool
    withdrawal_status::Bool
end

"""
    asset_status(client::BithumbClient, query::AssetStatusQuery)
    asset_status(client::BithumbClient = Bithumb.Spot.public_client; kw...)

[`GET /public/assetsstatus/multichain/{currency}`](https://apidocs.bithumb.com/reference/%EC%9E%85%EC%B6%9C%EA%B8%88-%EC%A7%80%EC%9B%90-%ED%98%84%ED%99%A9)

## Parameters:

| Parameter | Type         | Required | Description    |
|:----------|:-------------|:---------|:---------------|
| currency  | String       | false    | Default: "ALL" |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bithumb

result = Bithumb.Spot.asset_status(; 
    currency = "ADA",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"0000",
  "date":null,
  "data":[
    {
      "currency":"ADA",
      "net_type":"ADA",
      "deposit_status":true,
      "withdrawal_status":true
    }
  ]
}
```
"""
function asset_status(client::BithumbClient, query::AssetStatusQuery)
    return APIsRequest{Data{Vector{AssetStatusData}}}("GET", "public/assetsstatus/multichain/$(query.currency)", query)(client)
end

function asset_status(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return asset_status(client, AssetStatusQuery(; kw...))
end

end
