module Candles

export CandlesQuery,
    CandlesData,
    candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m15 m30 h1 h3 h6 h12 d1 w1 d14 M1

@enumx Section last hist

Base.@kwdef struct CandlesQuery <: BitfinexPublicQuery
    timeframe::TimeInterval.T
    symbol::String
    section::Section.T = Section.hist
    limit::Int64 = 125
    start::Maybe{DateTime} = nothing
    _end::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{CandlesQuery}, ::Val{:timeframe}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlesQuery}, ::Val{:symbol}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlesQuery}, ::Val{:section}) = true

function Serde.ser_type(::Type{CandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h3  && return "3h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1D"
    x == TimeInterval.w1  && return "1W"
    x == TimeInterval.d14 && return "14D"
    x == TimeInterval.M1  && return "1M"
end

struct CandlesData <: BitfinexData
    timestamp::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    candles(client::BitfinexClient, query::CandlesQuery)
    candles(client::BitfinexClient = Bitfinex.public_client; kw...)

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
using Dates
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.V2.candles(;
    timeframe = Bitfinex.V2.Candles.TimeInterval.m5,
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
function candles(client::BitfinexClient, query::CandlesQuery)
    timeframe = Serde.ser_type(CandlesQuery, query.timeframe)
    section = Serde.ser_type(CandlesQuery, query.section)
    return if section == Section.hist
        APIsRequest{Vector{CandlesData}}("GET", "v2/candles/trade:$(timeframe):$(query.symbol)/$(section)", query)(client)
    else
        APIsRequest{CandlesData}("GET", "v2/candles/trade:$(timeframe):$(query.symbol)/$(section)", query)(client)
    end
end

function candles(client::BitfinexClient = Bitfinex.public_client; kw...)
    return candles(client, CandlesQuery(; kw...))
end

end
