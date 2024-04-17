module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Cryptocom
using CryptoAPIs.Cryptocom: Data
using CryptoAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m5 m15 m30 h1 h2 h4 h12 d1 d7 d14 M1

Base.@kwdef struct CandleQuery <: CryptocomPublicQuery
    instrument_name::String
    timeframe::Maybe{TimeInterval} = nothing
    count::Maybe{Int64} = nothing
    start_ts::Maybe{NanoDate} = nothing
    end_ts::Maybe{NanoDate} = nothing
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
  x == m1  && return "1m"
  x == m5  && return "5m"
  x == m15 && return "15m"
  x == m30 && return "30m"
  x == h1  && return "1h"
  x == h2  && return "2h"
  x == h4  && return "4h"
  x == h12 && return "12h"
  x == d1  && return "1D"
  x == d7  && return "7D"
  x == d14  && return "14D"
  x == M1  && return "1M"
end

struct CandleInfo <: CryptocomData
  o::Maybe{Float64}
  h::Maybe{Float64}
  l::Maybe{Float64}
  c::Maybe{Float64}
  v::Maybe{Float64}
  t::NanoDate
end

function Serde.isempty(::Type{CandleInfo}, x)::Bool
  return x === ""
end

struct CandleData <: CryptocomData
    interval::String
    data::Vector{CandleInfo}
    instrument_name::String
end

function Serde.isempty(::Type{CandleData}, x)::Bool
  return x == []
end

"""
    candle(client::CryptocomClient, query::CandleQuery)
    candle(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)

Retrieves candlesticks (k-line data history) over a given period for an instrument.

[`GET public/get-candlestick`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-candlestick)

## Parameters:

| Parameter       | Type         | Required | Description                             |
|:----------------|:-------------|:---------|:----------------------------------------|
| instrument_name | String       | true     |                                         |
| timeframe       | TimeInterval | false    | m1 m5 m15 m30 h1 h2 h4 h12 d1 d7 d14 M1 |
| count           | Int64        | false    |                                         |
| start_ts        | Int64        | false    |                                         |
| end_ts          | Int64        | false    |                                         |

## Code samples:

```julia
using Serde
using CryptoAPIs.Cryptocom

result = Cryptocom.Spot.candle(;
    instrument_name = "BTC_USDT",
    timeframe = Cryptocom.Spot.Candle.M1,
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":-1,
  "method":"public/get-candlestick",
  "code":"0",
  "result":{
    "interval":"1M",
    "data":[
      {
        "o":19000.0,
        "h":22982.05,
        "l":15492.33,
        "c":17170.28,
        "v":150666.07457,
        "t":"2022-11-01T00:00:00"
      },
      {
        "o":17166.5,
        "h":18372.46,
        "l":16263.22,
        "c":16539.69,
        "v":51215.88412,
        "t":"2022-12-01T00:00:00"
      ...
    ],
    "instrument_name":"BTC_USDT"
  }
}
```
"""
function candle(client::CryptocomClient, query::CandleQuery)
    return APIsRequest{Data{CandleData}}("GET", "public/get-candlestick", query)(client)
end

function candle(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
