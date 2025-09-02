module ProductsCandles

export ProductsCandlesQuery,
    ProductsCandlesData,
    products_candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m15 h1 h6 d1

Base.@kwdef struct ProductsCandlesQuery <: CoinbasePublicQuery
    granularity::TimeInterval.T
    product_id::String
    start::Maybe{DateTime} = nothing
    _end::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{ProductsCandlesQuery}, ::Val{:product_id}) = true

function Serde.ser_type(::Type{<:ProductsCandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "60"
    x == TimeInterval.m5  && return "300"
    x == TimeInterval.m15 && return "900"
    x == TimeInterval.h1  && return "3600"
    x == TimeInterval.h6  && return "21600"
    x == TimeInterval.d1  && return "86400"
end

struct ProductsCandlesData <: CoinbaseData
    time::Maybe{NanoDate}
    low::Maybe{Float64}
    high::Maybe{Float64}
    open::Maybe{Float64}
    close::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    products_candles(client::CoinbaseClient, query::ProductsCandlesQuery)
    products_candles(client::CoinbaseClient = Coinbase.ExhcangeAPI.public_client; kw...)

Get rates for a single product by product ID, grouped in buckets.

[`GET products/{product_id}/candles`](https://docs.cloud.coinbase.com/advanced-trade-api/reference/retailbrokerageapi_getcandles)

## Parameters:

| Parameter   | Type         | Required | Description        |
|:------------|:-------------|:---------|:-------------------|
| granularity | TimeInterval | true     | m1 m5 m15 h1 h6 d1 |
| product_id  | String       | true     |                    |
| start       | DateTime     | false    |                    |
| _end        | DateTime     | false    |                    |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

result = Coinbase.ExchangeAPI.products_candles(;
    granularity = Coinbase.ExchangeAPI.ProductsCandles.TimeInterval.d1,
    product_id = "BTC-USD",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "time":"2024-03-21T00:00:00",
    "low":0.617,
    "high":0.648,
    "open":0.637,
    "close":0.632,
    "volume":417732.13
  },
  ...
]
```
"""
function products_candles(client::CoinbaseClient, query::ProductsCandlesQuery;)
    return APIsRequest{Vector{ProductsCandlesData}}("GET", "products/$(query.product_id)/candles", query)(client)
end

function products_candles(client::CoinbaseClient = Coinbase.ExchangeAPI.public_client; kw...)
    return products_candles(client, ProductsCandlesQuery(; kw...))
end

end
