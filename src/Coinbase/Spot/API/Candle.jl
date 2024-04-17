module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Coinbase
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m15 h1 h6 d1

Base.@kwdef struct CandleQuery <: CoinbasePublicQuery
    granularity::TimeInterval
    start::Maybe{DateTime} = nothing
    _end::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "60"
    x == m5  && return "300"
    x == m15 && return "900"
    x == h1  && return "3600"
    x == h6  && return "21600"
    x == d1  && return "86400"
end

struct CandleData <: CoinbaseData
    time::Maybe{NanoDate}
    low::Maybe{Float64}
    high::Maybe{Float64}
    open::Maybe{Float64}
    close::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    candle(client::CoinbaseClient, query::CandleQuery)
    candle(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)

Get rates for a single product by product ID, grouped in buckets.

[`GET products/{product_id}/candles`](https://docs.cloud.coinbase.com/advanced-trade-api/reference/retailbrokerageapi_getcandles)

## Parameters:

| Parameter   | Type         | Required | Description        |
|:------------|:-------------|:---------|:-------------------|
| granularity | TimeInterval | true     | m1 m5 m15 h1 h6 d1 |
| start       | DateTime     | false    |                    |
| _end        | DateTime     | false    |                    |

## Code samples:

```julia
using Serde
using CryptoAPIs.Coinbase

result = Coinbase.Spot.candle(;
    granularity = Coinbase.Spot.Candle.d1
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
function candle(client::CoinbaseClient, query::CandleQuery; product_id::String)
    return APIsRequest{Vector{CandleData}}("GET", "products/$product_id/candles", query)(client)
end

function candle(client::CoinbaseClient = Coinbase.Spot.public_client; product_id::String, kw...)
    return candle(client, CandleQuery(; kw...); product_id = product_id)
end

end
