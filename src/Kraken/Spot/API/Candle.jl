module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest
import CryptoExchangeAPIs: prepare_json!

@enum TimeInterval m1 m5 m15 m30 h1 h4 d1 w1 d15

Base.@kwdef struct CandleQuery <: KrakenPublicQuery
    pair::String
    interval::Maybe{TimeInterval} = nothing
    since::Maybe{DateTime} = nothing
end

function Serde.SerQuery.ser_type(::Type{CandleQuery}, x::DateTime)::Int64
    return round(Int64, datetime2unix(x))
end

function Serde.ser_type(::Type{CandleQuery}, x::TimeInterval)::Int64
    x == m1  && return 1
    x == m5  && return 5
    x == m15 && return 15
    x == m30 && return 30
    x == h1  && return 60
    x == h4  && return 240
    x == d1  && return 1440
    x == w1  && return 10080
    x == d15 && return 21600
end

struct CandleData <: KrakenData
    time::NanoDate
    open::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    close::Maybe{Float64}
    vwap::Maybe{Float64}
    volume::Maybe{Float64}
    count::Maybe{Int64}
    last::Maybe{NanoDate}
end

function prepare_json!(::Type{T}, json::Dict{String,Any}) where {T<:Data{Dict{String,Vector{CandleData}}}}
    for (_, item) in json["result"]
        if item isa Vector
            for i in item
                push!(i, json["result"]["last"])
            end
        end
    end
    delete!(json["result"], "last")
    return json
end

"""
    candle(client::KrakenClient, query::CandleQuery)
    candle(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get OHLC data for a given market.

[`GET 0/public/OHLC`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getOHLCData)

## Parameters:

| Parameter | Type           | Required | Description                   |
|:----------|:---------------|:---------|:------------------------------|
| pair      | String         | true     |                               |
| interval  | TimeInterval   | false    | m1 m5 m15 m30 h1 h4 d1 w1 d15 |
| since     | DateTime       | false    |                               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kraken

result = Kraken.Spot.candle(;
    pair = "ACAUSD",
    interval = CryptoExchangeAPIs.Kraken.Spot.Candle.h1,
    since = now(UTC) - Hour(1),
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "ACAUSD":
    [
      {
        "time":"2024-05-15T17:00:00",
        "open":0.106,
        "high":0.106,
        "low":0.106,
        "close":0.106,
        "vwap":0.0,
        "volume":0.0,
        "count":0,
        "last":"2024-05-15T16:45:00"
      },
      ...
    ]
  }
}
```
"""
function candle(client::KrakenClient, query::CandleQuery)
    return APIsRequest{Data{Dict{String,Vector{CandleData}}}}("GET", "0/public/OHLC", query)(client)
end

function candle(client::KrakenClient = Kraken.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
