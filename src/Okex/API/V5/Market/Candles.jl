module Candles

export CandlesQuery,
    CandlesData,
    candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okex
using CryptoExchangeAPIs.Okex: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3

Base.@kwdef struct CandlesQuery <: OkexPublicQuery
    instId::String
    after::Maybe{DateTime} = nothing
    bar::Maybe{TimeInterval.T} = nothing
    before::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:CandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1H"
    x == TimeInterval.h2  && return "2H"
    x == TimeInterval.h4  && return "4H"
    x == TimeInterval.h6  && return "6Hutc"
    x == TimeInterval.h12 && return "12Hutc"
    x == TimeInterval.d1  && return "1Dutc"
    x == TimeInterval.d2  && return "2Dutc"
    x == TimeInterval.d3  && return "3Dutc"
    x == TimeInterval.w1  && return "1Wutc"
    x == TimeInterval.M1  && return "1Mutc"
    x == TimeInterval.M3  && return "3Mutc"
end

struct CandlesData <: OkexData
    openTime::Maybe{NanoDate}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    vol::Maybe{Float64}
    volCcy::Maybe{Float64}
    volCcyQuote::Maybe{Float64}
    confirm::Maybe{Int64}
end

"""
    candles(client::OkexClient, query::CandlesQuery)
    candles(client::OkexClient = Okex.Spot.public_client; kw...)

Retrieve the candlestick charts.

[`GET api/v5/market/candles`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-candlesticks)

## Parameters:

| Parameter | Type         | Required | Description                                        |
|:----------|:-------------|:---------|:---------------------------------------------------|
| instId    | String       | true     |                                                    |
| after     | DateTime     | false    |                                                    |
| bar       | TimeInterval | false    | m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3 |
| before    | DateTime     | false    |                                                    |
| limit     | Int64        | false    |                                                    |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Okex

result = Okex.Spot.candles(;
    instId = "BTC-USDT",
    bar = Okex.Spot.Candles.d1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "msg":"",
  "code":0,
  "data":[
    {
      "openTime":"2024-04-11T00:00:00",
      "openPrice":70637.1,
      "highPrice":71315.9,
      "lowPrice":69544.8,
      "closePrice":70211.3,
      "vol":9281.9689485,
      "volCcy":6.537022764980018e8,
      "volCcyQuote":6.537022764980018e8,
      "confirm":0
    },
    ...
  ]
}
```
"""
function candles(client::OkexClient, query::CandlesQuery)
    return APIsRequest{Data{CandlesData}}("GET", "api/v5/market/candles", query)(client)
end

function candles(client::OkexClient = Okex.public_client; kw...)
    return candles(client, CandlesQuery(; kw...))
end

end
