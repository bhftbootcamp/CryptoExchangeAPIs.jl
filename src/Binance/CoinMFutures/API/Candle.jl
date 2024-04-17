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
    openTime::NanoDate
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    volume::Maybe{Float64}
    closeTime::NanoDate
    baseAssetVolume::Maybe{Float64}
    tradesNumber::Maybe{Int64}
    takerBuyVolume::Maybe{Float64}
    takerBuyBaseAssetVolume::Maybe{Float64}
end

"""
    candle(client::BinanceClient, query::CandleQuery)
    candle(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)

Kline/candlestick bars for a symbol.

[`GET dapi/v1/klines`](https://binance-docs.github.io/apidocs/delivery/en/#kline-candlestick-data)

## Parameters:

| Parameter | Type     | Required | Description                                    |
|:----------|:---------|:---------|:-----------------------------------------------|
| symbol    | String   | true     |                                                |
| interval  | Period   | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1|
| endTime   | DateTime | false    |                                                |
| limit     | Int64    | false    |                                                |
| startTime | DateTime | false    |                                                |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.CoinMFutures.candle(;
    symbol = "ADAUSD_PERP",
    interval = Binance.CoinMFutures.Candle.M1,
) 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "openTime":"2023-10-01T00:00:00",
    "openPrice":0.2538,
    "highPrice":0.3049,
    "lowPrice":0.2387,
    "closePrice":0.2931,
    "volume":3.1780325e7,
    "closeTime":"2023-10-31T23:59:59.999000064",
    "baseAssetVolume":1.189509044956558e9,
    "tradesNumber":795986,
    "takerBuyVolume":1.5506238e7,
    "takerBuyBaseAssetVolume":5.799281977142488e8
  },
  ...
]
```
"""
function candle(client::BinanceClient, query::CandleQuery)
    return APIsRequest{Vector{CandleData}}("GET", "dapi/v1/klines", query)(client)
end

function candle(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
