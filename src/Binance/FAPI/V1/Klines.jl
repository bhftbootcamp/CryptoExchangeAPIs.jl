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
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
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
    klines(client::BinanceClient, query::KlinesQuery)
    klines(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

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
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.klines(;
    symbol = "ADAUSDT",
    interval = Binance.FAPI.V1.Klines.TimeInterval.M1,
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
function klines(client::BinanceClient, query::KlinesQuery)
    return APIsRequest{Vector{KlinesData}}("GET", "fapi/v1/klines", query)(client)
end

function klines(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return klines(client, KlinesQuery(; kw...))
end

end
