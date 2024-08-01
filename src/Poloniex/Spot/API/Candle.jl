module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Poloniex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m10 m15 m30 h1 h2 h4 h6 h12 d1 d3 w1 M1

Base.@kwdef struct CandleQuery <: PoloniexPublicQuery
    interval::TimeInterval
    symbol::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_ignore_field(::Type{<:CandleQuery}, ::Val{:symbol})::Bool
    return true
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "MINUTE_1"
    x == m5  && return "MINUTE_5"
    x == m10 && return "MINUTE_10"
    x == m15 && return "MINUTE_15"
    x == m30 && return "MINUTE_30"
    x == h1  && return "HOUR_1"
    x == h2  && return "HOUR_2"
    x == h4  && return "HOUR_4"
    x == h6  && return "HOUR_6"
    x == h12 && return "HOUR_12"
    x == d1  && return "DAY_1"
    x == d3  && return "DAY_3"
    x == w1  && return "WEEK_1"
    x == M1  && return "MONTH_1"
end

struct CandleData <: PoloniexData
    low::Maybe{Float64}
    high::Maybe{Float64}
    open::Maybe{Float64}
    close::Maybe{Float64}
    amount::Maybe{Float64}
    quantity::Maybe{Float64}
    buyTakerAmount::Maybe{Float64}
    buyTakerQuantity::Maybe{Float64}
    tradeCount::Maybe{Int64}
    ts::Maybe{Int64}
    weightedAverage::Maybe{Float64}
    interval::Maybe{String}
    startTime::NanoDate
    closeTime::Maybe{NanoDate}
end

"""
    candle(client::PoloniexClient, query::CandleQuery)
    candle(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get latest trade price for all symbols.

[`GET markets/{symbol}/price`](https://api-docs.poloniex.com/spot/api/public/market-data)

## Parameters:

| Parameter | Type         | Required | Description |
|:----------|:-------------|:---------|:------------|
| interval  | TimeInterval | true     | `m1` `m5` `m10` `m15` `m30` `h1` `h2` `h4` `h6` `h12` `d1` `d3` `w1` `M1` |
| symbol    | String       | false    |             |
| startTime | DateTime     | false    |             |
| endTime   | DateTime     | false    |             |
| limit     | Int64        | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Poloniex

result = Poloniex.Spot.candle(;
    symbol = "BTC_USDT",
    interval = CryptoExchangeAPIs.Poloniex.Spot.Candle.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "low":65575.65,
    "high":65691.47,
    "open":65691.47,
    "close":65646.11,
    "amount":136992.38,
    "quantity":2.086813,
    "buyTakerAmount":70208.28,
    "buyTakerQuantity":1.069507,
    "tradeCount":117,
    "ts":1715873094983,
    "weightedAverage":65646.71,
    "interval":"MINUTE_5",
    "startTime":"2024-05-16T15:20:00",
    "closeTime":"2024-05-16T15:24:59.999000064"
  },
  ...
]
```
"""
function candle(client::PoloniexClient, query::CandleQuery; kw...)
    endpoint = isnothing(query.symbol) ? "markets/candles" : "markets/$(query.symbol)/candles"
    return APIsRequest{Vector{CandleData}}("GET", endpoint, query)(client)
end

function candle(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
