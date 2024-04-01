module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

Base.@kwdef struct CandleQuery <: BinancePublicQuery
    symbol::String
    interval::TimeInterval
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m3  && return "3m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h2  && return "2h"
    x == h4  && return "4h"
    x == h6  && return "6h"
    x == h8  && return "8h"
    x == h12 && return "12h"
    x == d1  && return "1d"
    x == d3  && return "3d"
    x == w1  && return "1w"
    x == M1  && return "1M"
end

struct CandleData <: BinanceData
    openTime::Maybe{NanoDate}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    volume::Maybe{Float64}
    closeTime::NanoDate
    quoteAssetVolume::Maybe{Float64}
    tradesNumber::Maybe{Int64}
    takerBuyBaseAssetVolume::Maybe{Float64}
    takerBuyQuoteAssetVolume::Maybe{Float64}
end

"""
    candle(client::BinanceClient, query::CandleQuery)
    candle(client::BinanceClient = Binance.Spot.public_client; kw...)

Kline/candlestick bars for a symbol.

[`GET api/v3/klines`](https://binance-docs.github.io/apidocs/spot/en/#kline-candlestick-data)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| interval  | Period   | true     |             |
| endTime   | DateTime | false    |             |
| limit     | Int64    | false    |             |
| startTime | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.Spot.candle(;
    symbol = "ADAUSDT",
    interval = Binance.Spot.Candle.M1,
) 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "openTime":"2018-04-01T00:00:00",
    "openPrice":0.25551,
    "highPrice":0.3866,
    "lowPrice":0.23983,
    "closePrice":0.34145,
    "volume":1.17451580874e9,
    "closeTime":"2018-04-30T23:59:59.999000064",
    "quoteAssetVolume":3.597636214561159e8,
    "tradesNumber":759135,
    "takerBuyBaseAssetVolume":5.556192707e8,
    "takerBuyQuoteAssetVolume":1.706766832130686e8
  },
  ...
]
```
"""
function candle(client::BinanceClient, query::CandleQuery)
    return APIsRequest{Vector{CandleData}}("GET", "api/v3/klines", query)(client)
end

function candle(client::BinanceClient = Binance.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
