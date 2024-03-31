module TopLongShortAccountRatio

export TopLongShortAccountRatioQuery,
    TopLongShortAccountRatioData,
    top_long_short_account_ratio

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum Period m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct TopLongShortAccountRatioQuery <: BinancePublicQuery
    symbol::String
    period::Period
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:TopLongShortAccountRatioQuery}, x::Period)::String
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

struct TopLongShortAccountRatioData <: BinanceData
    symbol::String
    longShortRatio::Maybe{Float64}
    longAccount::Maybe{Float64}
    shortAccount::Maybe{Float64}
    timestamp::NanoDate
end

"""
    top_long_short_account_ratio(client::BinanceClient, query::TopLongShortAccountRatioQuery)
    top_long_short_account_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET futures/data/topLongShortAccountRatio`](https://binance-docs.github.io/apidocs/futures/en/#top-trader-long-short-ratio-accounts)

## Parameters:

| Parameter    | Type           | Required | Description                                    |
|:-------------|:---------------|:---------|:-----------------------------------------------|
| symbol       | String         | true     |                                                |
| period       | Period         | true     | m5, m15, m30, h1, h2, h4, h6, h12, d1          |
| endTime      | DateTime       | false    |                                                |
| limit        | Int64          | false    | default 30, max 500                            |
| startTime    | DateTime       | false    |                                                |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.top_long_short_account_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TopLongShortAccountRatio.h1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "longShortRatio":1.5189,
    "longAccount":0.603,
    "shortAccount":0.397,
    "timestamp":"2024-03-30T15:00:00"
  },
  ...
]
```
"""
function top_long_short_account_ratio(client::BinanceClient, query::TopLongShortAccountRatioQuery)
    return APIsRequest{Vector{TopLongShortAccountRatioData}}("GET", "futures/data/topLongShortAccountRatio", query)(client)
end

function top_long_short_account_ratio(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return top_long_short_account_ratio(client, TopLongShortAccountRatioQuery(; kw...))
end

end