module LongShortRatio

export LongShortRatioQuery,
    LongShortRatioData,
    long_short_ratio

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct LongShortRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:LongShortRatioQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
end

struct LongShortRatioData <: BinanceData
    symbol::String
    longShortRatio::Maybe{Float64}
    longAccount::Maybe{Float64}
    shortAccount::Maybe{Float64}
    timestamp::NanoDate
end

"""
    long_short_ratio(client::BinanceClient, query::LongShortRatioQuery)
    long_short_ratio(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

[`GET futures/data/globalLongShortAccountRatio`](https://binance-docs.github.io/apidocs/futures/en/#long-short-ratio)

## Parameters:

| Parameter    | Type           | Required | Description                   |
|:-------------|:---------------|:---------|:------------------------------|
| symbol       | String         | true     |                               |
| period       | TimeInterval   | true     | m5 m15 m30 h1 h2 h4 h6 h12 d1 |
| endTime      | DateTime       | false    |                               |
| limit        | Int64          | false    | Default: 30, Max: 500         |
| startTime    | DateTime       | false    |                               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.Futures.Data.long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.LongShortRatio.TimeInterval.h1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "longShortRatio":1.3305,
    "longAccount":0.5709,
    "shortAccount":0.4291,
    "timestamp":"2024-03-29T12:00:00"
  },
  ...
]
```
"""
function long_short_ratio(client::BinanceClient, query::LongShortRatioQuery)
    return APIsRequest{Vector{LongShortRatioData}}("GET", "futures/data/globalLongShortAccountRatio", query)(client)
end

function long_short_ratio(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return long_short_ratio(client, LongShortRatioQuery(; kw...))
end

end
