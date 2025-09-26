module GetCandlestick

export GetCandlestickQuery,
    GetCandlestickData,
    get_candlestick

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Cryptocom
using CryptoExchangeAPIs.Cryptocom: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m5 m15 m30 h1 h2 h4 h12 d1 d7 d14 M1

Base.@kwdef struct GetCandlestickQuery <: CryptocomPublicQuery
    instrument_name::String
    timeframe::Maybe{TimeInterval.T} = nothing
    count::Maybe{Int64} = nothing
    start_ts::Maybe{DateTime} = nothing
    end_ts::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:GetCandlestickQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1D"
    x == TimeInterval.d7  && return "7D"
    x == TimeInterval.d14 && return "14D"
    x == TimeInterval.M1  && return "1M"
end

struct GetCandlestickInfo <: CryptocomData
    o::Maybe{Float64}
    h::Maybe{Float64}
    l::Maybe{Float64}
    c::Maybe{Float64}
    v::Maybe{Float64}
    t::NanoDate
end

function Serde.isempty(::Type{GetCandlestickInfo}, x)::Bool
    return x === ""
end

struct GetCandlestickData <: CryptocomData
    interval::String
    data::Vector{GetCandlestickInfo}
    instrument_name::String
end

function Serde.isempty(::Type{GetCandlestickData}, x)::Bool
    return x == []
end

"""
    get_candlestick(client::CryptocomClient, query::GetCandlestickQuery)
    get_candlestick(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)

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
using CryptoExchangeAPIs.Cryptocom

result = Cryptocom.Spot.get_candlestick(;
    instrument_name = "BTC_USDT",
    timeframe = Cryptocom.Spot.GetCandlestick.M1,
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
      ...
    ],
    "instrument_name":"BTC_USDT"
  }
}
```
"""
function get_candlestick(client::CryptocomClient, query::GetCandlestickQuery)
    return APIsRequest{Data{GetCandlestickData}}("GET", "public/get-candlestick", query)(client)
end

function get_candlestick(client::CryptocomClient = Cryptocom.public_client; kw...)
    return get_candlestick(client, GetCandlestickQuery(; kw...))
end

end
