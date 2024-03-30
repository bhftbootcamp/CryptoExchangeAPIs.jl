module LongShortRatio

export LongShortRatioQuery,
    LongShortRatioData,
    longshort_ratio

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum Period m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct LongShortRatioQuery <: BinancePublicQuery
    symbol::String
    period::Period
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:LongShortRatioQuery}, x::Period)::String
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
    longshort_ratio(client::BinanceClient, query::LongShortRatioQuery)
    longshort_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET futures/data/globalLongShortAccountRatio`](https://binance-docs.github.io/apidocs/futures/en/#top-trader-long-short-ratio-positions)

## Parameters:

| Parameter    | Type           | Required | Description                                    |
|:-------------|:---------------|:---------|:-----------------------------------------------|
| symbol       | String         | true     |                                                |
| period       | Period         | true     | "5m","15m","30m","1h","2h","4h","6h","12h","1d"|
| endTime      | DateTime       | false    |                                                |
| limit        | Int64          | false    | default 30, max 500                            |
| startTime    | DateTime       | false    |                                                |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.longshort_ratio(;
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
function longshort_ratio(client::BinanceClient, query::LongShortRatioQuery)
    return APIsRequest{Vector{LongShortRatioData}}("GET", "futures/data/globalLongShortAccountRatio", query)(client)
end

function longshort_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return longshort_ratio(client, LongShortRatioQuery(; kw...))
end

end
