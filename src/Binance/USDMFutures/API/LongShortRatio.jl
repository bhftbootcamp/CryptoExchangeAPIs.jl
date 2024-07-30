module LongShortRatio

export LongShortRatioQuery,
    LongShortRatioData,
    long_short_ratio

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct LongShortRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:LongShortRatioQuery}, x::TimeInterval)::String
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h2  && return "2h"
    x == h4  && return "4h"
    x == h6  && return "6h"
    x == h12 && return "12h"
    x == d1  && return "1d"
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
    long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

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

result = Binance.USDMFutures.long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.LongShortRatio.h1,
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

function long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return long_short_ratio(client, LongShortRatioQuery(; kw...))
end

end
