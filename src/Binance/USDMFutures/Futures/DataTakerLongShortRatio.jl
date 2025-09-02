module DataTakerLongShortRatio

export DataTakerLongShortRatioQuery,
    DataTakerLongShortRatioData,
    data_taker_long_short_ratio

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct DataTakerLongShortRatioQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:DataTakerLongShortRatioQuery}, x::TimeInterval.T)::String
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

struct DataTakerLongShortRatioData <: BinanceData
    buySellRatio::Maybe{Float64}
    buyVol::Maybe{Float64}
    sellVol::Maybe{Float64}
    timestamp::NanoDate
end

"""
    data_taker_long_short_ratio(client::BinanceClient, query::DataTakerLongShortRatioQuery)
    data_taker_long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

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

result = Binance.USDMFutures.Futures.data_taker_long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.Futures.DataTakerLongShortRatio.TimeInterval.h1,
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
function data_taker_long_short_ratio(client::BinanceClient, query::DataTakerLongShortRatioQuery)
    return APIsRequest{Vector{DataTakerLongShortRatioData}}("GET", "futures/data/takerlongshortRatio", query)(client)
end

function data_taker_long_short_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return data_taker_long_short_ratio(client, DataTakerLongShortRatioQuery(; kw...))
end

end
