module OpenInterestHist

export OpenInterestHistQuery,
    OpenInterestHistData,
    open_interest_hist

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct OpenInterestHistQuery <: BinancePublicQuery
    symbol::String
    period::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:OpenInterestHistQuery}, x::TimeInterval.T)::String
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

struct OpenInterestHistData <: BinanceData
    symbol::String
    sumOpenInterest::Maybe{Float64}
    sumOpenInterestValue::Maybe{Float64}
    timestamp::NanoDate
end

"""
    open_interest_hist(client::BinanceClient, query::OpenInterestHistQuery)
    open_interest_hist(client::BinanceClient = Binance.Futures.public_client; kw...)

[`GET futures/data/openInterestHist`](https://binance-docs.github.io/apidocs/futures/en/#open-interest-statistics)

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

result = Binance.Futures.Data.open_interest_hist(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.OpenInterestHist.TimeInterval.h1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "sumOpenInterest":81737.468,
    "sumOpenInterestValue":5.730969977716018e9,
    "timestamp":"2024-03-29T15:00:00"
  },
  ...
]
```
"""
function open_interest_hist(client::BinanceClient, query::OpenInterestHistQuery)
    return APIsRequest{Vector{OpenInterestHistData}}("GET", "futures/data/openInterestHist", query)(client)
end

function open_interest_hist(client::BinanceClient = Binance.public_fapi_client; kw...)
    return open_interest_hist(client, OpenInterestHistQuery(; kw...))
end

end
