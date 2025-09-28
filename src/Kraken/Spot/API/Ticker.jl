module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

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
    o::Float64
end

"""
    ticker(client::KrakenClient, query::TickerQuery)
    ticker(client::KrakenClient = Kraken.Spot.public_client; kw...)

Get ticker information for all or requested markets.

[`GET 0/public/Ticker`](https://docs.kraken.com/rest/#tag/Spot-Market-Data/operation/getTickerInformation)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| pair      | String     | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kraken

result = Kraken.Spot.ticker(;
    pair = "XBTUSD",
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
