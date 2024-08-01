module TopLongShortPositionRatio

export TopLongShortPositionRatioQuery,
    TopLongShortPositionRatioData,
    top_long_short_position_ratio

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct TopLongShortPositionRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:TopLongShortPositionRatioQuery}, x::TimeInterval)::String
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

struct TopLongShortPositionRatioData <: BinanceData
    symbol::String
    longShortRatio::Maybe{Float64}
    longAccount::Maybe{Float64}
    shortAccount::Maybe{Float64}
    timestamp::NanoDate
end

"""
    top_long_short_position_ratio(client::BinanceClient, query::TopLongShortPositionRatioQuery)
    top_long_short_position_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET futures/data/topLongShortPositionRatio`](https://binance-docs.github.io/apidocs/futures/en/#top-trader-long-short-ratio-positions)

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

result = Binance.USDMFutures.top_long_short_position_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TopLongShortPositionRatio.h1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "longShortRatio":1.3855,
    "longAccount":0.5808,
    "shortAccount":0.4192,
    "timestamp":"2024-03-30T15:00:00"
  },
  ...
]
```
"""
function top_long_short_position_ratio(client::BinanceClient, query::TopLongShortPositionRatioQuery)
    return APIsRequest{Vector{TopLongShortPositionRatioData}}("GET", "futures/data/topLongShortPositionRatio", query)(client)
end

function top_long_short_position_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return top_long_short_position_ratio(client, TopLongShortPositionRatioQuery(; kw...))
end

end
