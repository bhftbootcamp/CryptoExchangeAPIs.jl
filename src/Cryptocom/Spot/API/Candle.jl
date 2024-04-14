module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Cryptocom
using CryptoAPIs.Cryptocom: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct CandleQuery <: CryptocomPublicQuery
    instrument_name::String
    timeframe::Maybe{String} = nothing
    count::Maybe{Int64} = nothing
    start_ts::Maybe{Int64} = nothing
    end_ts::Maybe{Int64} = nothing
end

struct CandleStruct <: CryptocomData
  o::Maybe{Float64}
  h::Maybe{Float64}
  l::Maybe{Float64}
  c::Maybe{Float64}
  v::Maybe{Float64}
  t::Maybe{Int64}
end

struct CandleData <: CryptocomData
    interval::String
    data::Vector{CandleStruct}
    instrument_name::String
end

"""
    candle(client::CryptocomClient, query::CandleQuery)
    candle(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)

Retrieves candlesticks (k-line data history) over a given period for an instrument.

[`GET public/get-candlestick`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-candlestick)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| instrument_name | String   | true     |             |
| timeframe       | String   | false    |             |
| count           | Int64    | false    |             |
| start_ts        | Int64    | false    |             |
| end_ts          | Int64    | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Cryptocom

result = Cryptocom.Spot.candle(;
    instrument_name = "BTC_USDT",
    timeframe = "M1",
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
    "interval":"M1",
    "data":[
      {
        "o":"64098.90",
        "h":"64166.31",
        "l":"64091.36",
        "c":"64159.22",
        "v":"5.7552",
        "t":1713107100000
      },
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