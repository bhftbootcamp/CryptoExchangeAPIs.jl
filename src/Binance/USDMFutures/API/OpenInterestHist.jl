module OpenInterestHist

export OpenInterestHistQuery,
    OpenInterestHistData,
    open_interest_hist

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

@enum Period m5 m15 m30 h1 h2 h4 h6 h12 d1

Base.@kwdef struct OpenInterestHistQuery <: BinancePublicQuery
    symbol::String
    period::Period
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:OpenInterestHistQuery}, x::Period)::String
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

struct OpenInterestHistData <: BinanceData
    symbol::String
    sumOpenInterest::Maybe{Float64}
    sumOpenInterestValue::Maybe{Float64}
    timestamp::NanoDate
end

"""
    open_interest_hist(client::BinanceClient, query::OpenInterestHistQuery)
    open_interest_hist(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET futures/data/openInterestHist`](https://binance-docs.github.io/apidocs/futures/en/#open-interest-statistics)

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

result = Binance.USDMFutures.open_interest_hist(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.OpenInterestHist.h1,
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

function open_interest_hist(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return open_interest_hist(client, OpenInterestHistQuery(; kw...))
end

end