module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bitfinex
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m15 m30 h1 h3 h6 h12 d1 w1 d14 M1

@enum Section last hist

Base.@kwdef struct CandleQuery <: BitfinexPublicQuery
    timeframe::TimeInterval
    symbol::String
    section::Section = hist
    limit::Int64 = 125
    start::Maybe{DateTime} = nothing
    _end::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:timeframe}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:symbol}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:section}) = true

function Serde.ser_type(::Type{CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h3  && return "3h"
    x == h6  && return "6h"
    x == h12 && return "12h"
    x == d1  && return "1D"
    x == w1  && return "1W"
    x == d14 && return "14D"
    x == M1  && return "1M"
end

struct CandleData <: BitfinexData
    timestamp::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    candle(client::BitfinexClient, query::CandleQuery)
    candle(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)

The Candles endpoint provides OCHL (Open, Close, High, Low) and volume data for the specified funding currency or trading pair.
The endpoint provides the last 100 candles by default, but a limit and a start and/or end timestamp can be specified.

[`GET v2/candles/{candle}/{section}`](https://docs.bitfinex.com/reference/rest-public-candles)

## Parameters:

| Parameter | Type         | Required | Description                             |
|:----------|:-------------|:---------|:----------------------------------------|
| timeframe | TimeInterval | true     | m1 m5 m15 m30 h1 h3 h6 h12 d1 w1 d14 M1 |
| symbol    | String       | true     |                                         |
| section   | Section      | false    | Default: `hist`, Available: `last`      |
| limit     | Int64        | false    | Default: `125`                          |
| start     | DateTime     | false    |                                         |
| _end      | DateTime     | false    |                                         |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bitfinex

result = Bitfinex.Spot.candle(;
    timeframe = CryptoAPIs.Bitfinex.Spot.Candle.m5,
    symbol = "tBTCUSD",
    start = now(UTC) - Minute(100),
    _end = now(UTC) - Minute(10),
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "timestamp":"2024-05-19T14:35:00",
    "open":67089.0,
    "close":67032.0,
    "high":67089.0,
    "low":67032.0,
    "volume":0.32812637
  },
  ...
]
```
"""
function candle(client::BitfinexClient, query::CandleQuery)
    timeframe = Serde.ser_type(CandleQuery, query.timeframe)
    section   = Serde.ser_type(CandleQuery, query.section)
    return if section == hist
        APIsRequest{Vector{CandleData}}("GET", "v2/candles/trade:$(timeframe):$(query.symbol)/$(section)", query)(client)
    else
        APIsRequest{CandleData}("GET", "v2/candles/trade:$(timeframe):$(query.symbol)/$(section)", query)(client)
    end
end

function candle(client::BitfinexClient = Bitfinex.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
