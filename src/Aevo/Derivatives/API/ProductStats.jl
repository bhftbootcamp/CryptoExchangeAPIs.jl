module ProductStats

export ProductStatsQuery,
    ProductStatsData,
    product_stats

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Aevo
using CryptoAPIs: Maybe, APIsRequest

@enum InstrumentType OPTION SPOT PERPETUAL

Base.@kwdef struct ProductStatsQuery <: AevoPublicQuery
    asset::String
    instrument_type::InstrumentType
    end_time::Maybe{DateTime} = nothing
end

struct ProductStatsData <: AevoData
    asset::String
    open_interest::Dict{Symbol, Maybe{Float64}}
    daily_volume::Float64
    daily_buy_volume::Float64
    daily_sell_volume::Float64
    daily_volume_premium::Maybe{Float64}
    total_volume::Float64
    total_volume_premium::Maybe{Float64}
    daily_volume_contracts::Float64
    index_price::Float64
    index_daily_change::Float64
    mark_price::Float64
    mark_price_24h_ago::Float64
    mark_daily_change::Float64
    funding_daily_avg::Float64
    put_call_ratio::Maybe{Float64}
end

"""
    product_stats(client::AevoClient, query::ProductStatsQuery)
    product_stats(client::AevoClient = Aevo.Derivatives.public_client; kw...)

Returns the market statistics for the given asset.

[`GET statistics`](https://api-docs.aevo.xyz/reference/getstatistics)

## Code samples:

```julia
using Serde
using CryptoAPIs.Aevo

result = Aevo.Derivatives.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Derivatives.ProductStats.PERPETUAL,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asset":"ETH",
  "open_interest":{
    "total":2678.156722
  },
  "daily_volume":2.0555100110632844e7,
  "daily_buy_volume":9.661439151821265e6,
  "daily_sell_volume":1.0893660958811581e7,
  "daily_volume_premium":null,
  "total_volume":17795.39194288,
  "total_volume_premium":null,
  "daily_volume_contracts":6942.52,
  "index_price":2973.386837,
  "index_daily_change":14.858767,
  "mark_price":2972.9028,
  "mark_price_24h_ago":2964.452868,
  "mark_daily_change":8.449932,
  "funding_daily_avg":-4.0e-6,
  "put_call_ratio":null
}
```
"""
function product_stats(client::AevoClient, query::ProductStatsQuery)
    return APIsRequest{ProductStatsData}("GET", "statistics", query)(client)
end

function product_stats(client::AevoClient = Aevo.Derivatives.public_client; kw...)
    return product_stats(client, ProductStatsQuery(; kw...))
end

end