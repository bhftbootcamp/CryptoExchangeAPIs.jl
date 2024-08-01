module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m15 m30 h1 h2 h4 h8 h12 d1 w1

Base.@kwdef struct CandleQuery <: KucoinPublicQuery
    symbol::String
    granularity::TimeInterval
    from::Maybe{NanoDate} = nothing
    to::Maybe{NanoDate} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1"
    x == m5  && return "5"
    x == m15 && return "15"
    x == m30 && return "30"
    x == h1  && return "60"
    x == h2  && return "120"
    x == h4  && return "240"
    x == h8  && return "480"
    x == h12 && return "720"
    x == d1  && return "1440"
    x == w1  && return "10080"
end

struct CandleData <: KucoinData
    time::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    candle(client::KucoinClient, query::CandleQuery)
    candle(client::KucoinClient = Kucoin.Futures.public_client; kw...)

Request via this endpoint to get the kline of the specified symbol.

[`GET api/v1/kline/query`](https://www.kucoin.com/docs/rest/futures-trading/market-data/get-klines)

## Parameters:

| Parameter        | Type         | Required | Description                         |
|:-----------------|:-------------|:---------|:------------------------------------|
| symbol           | String       | true     |                                     |
| granularity      | TimeInterval | true     | m1 m5 m15 m30 h1 h2 h4 h8 h12 d1 w1 |
| from             | NanoDate     | false    |                                     |
| to               | NanoDate     | false    |                                     |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Futures.candle(;
    symbol = ".KXBT",
    granularity = Kucoin.Futures.Candle.m1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200000,
  "data":[
    {
      "time":"2024-05-14T20:37:00",
      "open":61593.03,
      "close":61593.82,
      "high":61593.02,
      "low":61593.82,
      "volume":0.0
    },
    ...
  ]
}
```
"""
function candle(client::KucoinClient, query::CandleQuery)
    return APIsRequest{Data{Vector{CandleData}}}("GET", "api/v1/kline/query", query)(client)
end

function candle(client::KucoinClient = Kucoin.Futures.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
