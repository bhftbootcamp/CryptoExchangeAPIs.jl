module Klines

export KlinesQuery,
    KlinesData,
    klines

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

Base.@kwdef struct KlinesQuery <: BinancePublicQuery
    symbol::String
    interval::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:KlinesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d3  && return "3d"
    x == TimeInterval.w1  && return "1w"
    x == TimeInterval.M1  && return "1M"
end

struct KlinesData <: BinanceData
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
    klines(client::BinanceClient, query::KlinesQuery)
    klines(client::BinanceClient = Binance.API.public_client; kw...)

Kline/candlestick bars for a symbol.

[`GET api/v3/klines`](https://binance-docs.github.io/apidocs/spot/en/#kline-candlestick-data)

## Parameters:

| Parameter | Type     | Required | Description                                     |
|:----------|:---------|:---------|:------------------------------------------------|
| symbol    | String   | true     |                                                 |
| interval  | Period   | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1 |
| endTime   | DateTime | false    |                                                 |
| limit     | Int64    | false    |                                                 |
| startTime | DateTime | false    |                                                 |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.API.V3.klines(;
    symbol = "ADAUSDT",
    interval = Binance.API.V3.Klines.TimeInterval.M1,
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
function klines(client::BinanceClient, query::KlinesQuery)
    return APIsRequest{Vector{KlinesData}}("GET", "api/v3/klines", query)(client)
end

function klines(client::BinanceClient = Binance.API.public_client; kw...)
    return klines(client, KlinesQuery(; kw...))
end

end
