module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Okex
using CryptoAPIs.Okex: Data
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3

Base.@kwdef struct CandleQuery <: OkexPublicQuery
    instId::String
    after::Maybe{DateTime} = nothing
    bar::Maybe{TimeInterval} = nothing
    before::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m3  && return "3m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1H"
    x == h2  && return "2H"
    x == h4  && return "4H"
    x == h6  && return "6Hutc"
    x == h12 && return "12Hutc"
    x == d1  && return "1Dutc"
    x == d2  && return "2Dutc"
    x == d3  && return "3Dutc"
    x == w1  && return "1Wutc"
    x == M1  && return "1Mutc"
    x == M3  && return "3Mutc"
end

struct CandleData <: OkexData
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
    candle(client::OkexClient, query::CandleQuery)
    candle(client::OkexClient = Okex.Spot.public_client; kw...)

Retrieve the candlestick charts.

[`GET api/v5/market/candles`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-candlesticks)

## Parameters:

| Parameter | Type         | Required | Description |
|:----------|:-------------|:---------|:------------|
| instId    | String       | true     |             |
| after     | DateTime     | false    |             |
| bar       | TimeInterval | false    |             |
| before    | DateTime     | false    |             |
| limit     | Int64        | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Okex

result = Okex.Spot.candle(;
    instId = "BTC-USDT",
    bar = Okex.Spot.Candle.d1,
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
function candle(client::OkexClient, query::CandleQuery)
    return APIsRequest{Data{CandleData}}("GET", "api/v5/market/candles", query)(client)
end

function candle(client::OkexClient = Okex.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
