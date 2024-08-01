module TakerLongShortRatio

export TakerLongShortRatioQuery,
    TakerLongShortRatioData,
    taker_long_short_ratio

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct TakerLongShortRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:TakerLongShortRatioQuery}, x::TimeInterval)::String
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

struct TakerLongShortRatioData <: BinanceData
    buySellRatio::Maybe{Float64}
    buyVol::Maybe{Float64}
    sellVol::Maybe{Float64}
    timestamp::NanoDate
end

"""
    taker_long_short_ratio(client::BinanceClient, query::TakerLongShortRatioQuery)
    taker_long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET futures/data/takerlongshortRatio`](https://binance-docs.github.io/apidocs/futures/en/#taker-buy-sell-volume)

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

result = Binance.USDMFutures.taker_long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TakerLongShortRatio.h1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "buySellRatio":0.6366,
    "buyVol":1277.042,
    "sellVol":2005.878,
    "timestamp":"2024-03-30T14:00:00"
  },
  ...
]
```
"""
function taker_long_short_ratio(client::BinanceClient, query::TakerLongShortRatioQuery)
    return APIsRequest{Vector{TakerLongShortRatioData}}("GET", "futures/data/takerlongshortRatio", query)(client)
end

function taker_long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return taker_long_short_ratio(client, TakerLongShortRatioQuery(; kw...))
end

end
