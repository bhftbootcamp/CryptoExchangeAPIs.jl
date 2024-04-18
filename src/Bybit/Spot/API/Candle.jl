module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bybit
using CryptoAPIs.Bybit: Data, List, Rows
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

Base.@kwdef struct CandleQuery <: BybitPublicQuery
    symbol::String
    interval::TimeInterval
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m3  && return "3m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h2  && return "2h"
    x == h4  && return "4h"
    x == h6  && return "6h"
    x == h8  && return "8h"
    x == h12 && return "12h"
    x == d1  && return "1d"
    x == d3  && return "3d"
    x == w1  && return "1w"
    x == M1  && return "1M"
end

struct CandleData <: BybitData
    c::Maybe{Float64}
    h::Maybe{Float64}
    l::Maybe{Float64}
    o::Maybe{Float64}
    s::Maybe{String}
    sn::Maybe{String}
    t::Maybe{NanoDate}
    v::Maybe{Float64}
end

"""
    Bybit(client::BybitClient, query::CandleQuery)
    Bybit(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /spot/v3/public/quote/kline`](https://bybit-exchange.github.io/docs/spot/public/kline#http-request)

## Parameters:

| Parameter | Type         | Required | Description                                     |
|:----------|:-------------|:---------|:------------------------------------------------|
| symbol    | String       | true     |                                                 |
| interval  | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1 |
| endTime   | DateTime     | false    |                                                 |
| limit     | Int64        | false    |                                                 |
| startTime | DateTime     | false    |                                                 |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bybit

result = Bybit.Spot.candle(;
    symbol = "ADAUSDT",
    interval = Bybit.Spot.Candle.M1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "list":[
      {
        "c":1.97,
        "h":2.303,
        "l":1.822,
        "o":2.105,
        "s":"ADAUSDT",
        "sn":"ADAUSDT",
        "t":"2021-10-01T00:00:00",
        "v":2.7565224e6
      },
      ...
    ],
    "nextPageCursor":null,
    "category":null
  },
  "retExtInfo":{},
  "time":"2024-03-25T18:36:39.372"
}
```
"""
function candle(client::BybitClient, query::CandleQuery)
    return APIsRequest{Data{List{CandleData}}}("GET", "spot/v3/public/quote/kline", query)(client)
end

function candle(client::BybitClient = Bybit.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
