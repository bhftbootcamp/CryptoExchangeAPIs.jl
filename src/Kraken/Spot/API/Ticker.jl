module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: KrakenPublicQuery
    pair::Maybe{String} = nothing
end

struct Level <: KrakenData
    price::Float64
    whole_lot_volume::Float64
    lot_volume::Float64
end

struct TickerData <: KrakenData
    a::Maybe{Level}
    b::Maybe{Level}
    c::Maybe{Vector{Float64}}
    v::Maybe{Vector{Float64}}
    p::Maybe{Vector{Float64}}
    t::Maybe{Vector{Int64}}
    l::Maybe{Vector{Float64}}
    h::Maybe{Vector{Float64}}
    o::Maybe{Float64}
end

function Serde.deser(::Type{Level}, x::Vector{Any})::Level
    return Level(
        tryparse(Float64, x[1]),
        tryparse(Float64, x[2]),
        tryparse(Float64, x[3]),
    )
end

"""
    ticker(client::KrakenClient, query::TickerQuery)
    ticker(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get ticker information for all or requested markets.

[`GET 0/public/Ticke`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getTickerInformation)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| pair      | String     | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kraken

result = Kraken.Spot.ticker(;
    air = "XBTUSD",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "XXBTZUSD":{
      "a":{
        "price":64847.8,
        "whole_lot_volume":6.0,
        "lot_volume":6.0
      },
      "b":{
        "price":64847.7,
        "whole_lot_volume":1.0,
        "lot_volume":1.0
      },
      "c":[
        64847.8,
        0.00011635
      ],
      "v":[
        2575.41519714,
        3075.93450804
      ],
      "p":[
        63743.49996,
        63382.82681
      ],
      "t":[
        28103,
        34075
      ],
      "l":[
        61325.4,
        61150.0
      ],
      "h":[
        65108.9,
        65108.9
      ],
      "o":61568.6
    }
  }
}
```
"""
function ticker(client::KrakenClient, query::TickerQuery)
    return APIsRequest{Data{Dict{String,TickerData}}}("GET", "0/public/Ticker", query)(client)
end

function ticker(client::KrakenClient = Kraken.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
