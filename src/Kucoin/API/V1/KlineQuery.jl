module KlineQuery

export KlineQueryQuery,
    KlineQueryData,
    kline_query

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m15 m30 h1 h2 h4 h8 h12 d1 w1

Base.@kwdef struct KlineQueryQuery <: KucoinPublicQuery
    symbol::String
    granularity::TimeInterval.T
    from::Maybe{NanoDate} = nothing
    to::Maybe{NanoDate} = nothing
end

function Serde.ser_type(::Type{<:KlineQueryQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1"
    x == TimeInterval.m5  && return "5"
    x == TimeInterval.m15 && return "15"
    x == TimeInterval.m30 && return "30"
    x == TimeInterval.h1  && return "60"
    x == TimeInterval.h2  && return "120"
    x == TimeInterval.h4  && return "240"
    x == TimeInterval.h8  && return "480"
    x == TimeInterval.h12 && return "720"
    x == TimeInterval.d1  && return "1440"
    x == TimeInterval.w1  && return "10080"
end

struct KlineQueryData <: KucoinData
    time::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    volume::Maybe{Float64}
end

"""
    kline_query(client::KucoinClient, query::KlineQueryQuery)
    kline_query(client::KucoinClient = Kucoin.Futures.public_client; kw...)

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

result = Kucoin.Futures.kline_query(;
    symbol = ".KXBT",
    granularity = Kucoin.Futures.KlineQuery.m1,
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
function kline_query(client::KucoinClient, query::KlineQueryQuery)
    return APIsRequest{Data{Vector{KlineQueryData}}}("GET", "api/v1/kline/query", query)(client)
end

function kline_query(client::KucoinClient = Kucoin.public_futures_client; kw...)
    return kline_query(client, KlineQueryQuery(; kw...))
end

end
