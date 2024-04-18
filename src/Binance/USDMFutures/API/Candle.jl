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
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
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
    openTime::NanoDate
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
    candle(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

Kline/candlestick bars for a symbol.

Wrapper for method: [`GET fapi/v3/klines`](https://binance-docs.github.io/apidocs/futures/en/#kline-candlestick-data).

## Parameters:

| Parameter  | Type            | Required | Description                                     |
|:-----------|:----------------|:---------|:------------------------------------------------|
| symbol     | String          | true     |                                                 |
| interval   | TimeInterval    | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1 |
| endTime    | DateTime        | false    |                                                 |
| limit      | Int64           | false    |                                                 |
| startTime  | DateTime        | false    |                                                 |


## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.candle(;
    symbol = "ADAUSDT",
    interval = Binance.USDMFutures.Candle.M1,
) 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "openTime":"2020-01-01T00:00:00",
    "openPrice":0.0545,
    "highPrice":0.05559,
    "lowPrice":0.05209,
    "closePrice":0.05387,
    "volume":2.44632854e8,
    "closeTime":"2020-01-31T23:59:59.999000064",
    "quoteAssetVolume":1.313060288191e7,
    "tradesNumber":40186,
    "takerBuyBaseAssetVolume":1.16954492e8,
    "takerBuyQuoteAssetVolume":6.28735588554e6
  },
  ...
]
```
"""
function candle(client::BinanceClient, query::CandleQuery)
    return APIsRequest{Vector{CandleData}}("GET", "fapi/v1/klines", query)(client)
end

function candle(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
