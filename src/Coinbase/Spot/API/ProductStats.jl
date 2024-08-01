module ProductStats

export ProductStatsQuery,
    ProductStatsData,
    product_stats

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ProductStatsQuery <: CoinbasePublicQuery
    #__ empty
end

struct ProductStatsData <: CoinbaseData
    open::Float64
    high::Float64
    low::Float64
    last::Float64
    volume::Float64
    volume_30day::Maybe{Float64}
    rfq_volume_24hour::Maybe{Float64}
    rfq_volume_30day::Maybe{Float64}
    conversions_volume_24hour::Maybe{Float64}
    conversions_volume_30day::Maybe{Float64}
end

"""
    product_stats(client::CoinbaseClient, query::ProductStatsQuery)
    product_stats(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)

Get rates for a single product by product ID, grouped in buckets.

[`GET products/{product_id}/stats`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductstats)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

result = Coinbase.Spot.product_stats()

to_pretty_json(result.result)
```

## Result:

```json
{
  "open":65837.77,
  "high":66944.06,
  "low":64500.0,
  "last":65975.28,
  "volume":15431.78734886,
  "volume_30day":648921.33864485,
  "rfq_volume_24hour":20.273182,
  "rfq_volume_30day":1452.764429,
  "conversions_volume_24hour":null,
  "conversions_volume_30day":null
}
```
"""
function product_stats(client::CoinbaseClient, query::ProductStatsQuery; product_id::String)
    return APIsRequest{ProductStatsData}("GET", "products/$product_id/stats", query)(client)
end

function product_stats(client::CoinbaseClient = Coinbase.Spot.public_client; product_id::String, kw...)
    return product_stats(client, ProductStatsQuery(; kw...); product_id = product_id)
end

end
