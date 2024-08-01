module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m10 m15 m30 h1 h2 h3 h6 h12 d1

Base.@kwdef struct CandleQuery <: DeribitPublicQuery
    end_timestamp::DateTime
    instrument_name::String
    resolution::TimeInterval
    start_timestamp::DateTime
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1"
    x == m3  && return "3"
    x == m5  && return "5"
    x == m10 && return "10"
    x == m15 && return "15"
    x == m30 && return "30"
    x == h1  && return "60"
    x == h2  && return "120"
    x == h3  && return "180"
    x == h6  && return "360"
    x == h12 && return "720"
    x == d1  && return "1D"
end

struct CandleData <: DeribitData
    close::Vector{Float64}
    cost::Vector{Float64}
    high::Vector{Float64}
    low::Vector{Float64}
    open::Vector{Float64}
    status::String
    ticks::Vector{NanoDate}
    volume::Vector{Float64}
end

"""
    candle(client::DeribitClient, query::CandleQuery)
    candle(client::DeribitClient = Deribit.Common.public_client; kw...)

Publicly available market data used to generate a TradingView candle chart.

[`GET api/v2/public/get_tradingview_chart_data`](https://docs.deribit.com/#public-get_tradingview_chart_data)

## Parameters:

| Parameter       | Type         | Required | Description                             |
|:----------------|:-------------|:---------|:----------------------------------------|
| end_timestamp   | DateTime     | true     |                                         |
| instrument_name | String       | true     |                                         |
| resolution      | TimeInterval | true     | m1 m3 m5 m10 m15 m30 h1 h2 h3 h6 h12 d1 |
| start_timestamp | DateTime     | true     |                                         |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Deribit

result = Deribit.Common.candle(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Minute(100),
    end_timestamp = now(UTC) - Hour(1),
    resolution = CryptoExchangeAPIs.Deribit.Common.Candle.m1,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":null,
  "jsonrpc":"2.0",
  "testnet":false,
  "usDiff":1746,
  "usOut":"2024-05-17T11:57:46.222272",
  "usIn":"2024-05-17T11:57:46.220526080",
  "result":{
    "close":[
      66324.5,
      ...
    ],
    "cost":[
      101810.0,
      ...
    ],
    "high":[
      66324.5,
      ...
    ],
    "low":[
      66323.0,
      ...
    ],
    "open":[
      66323.0,
      ...
    ],
    "status":"ok",
    "ticks":[
      "2024-05-17T10:17:00",
      ...
    ],
    "volume":[
      1.53504587,
      ...
    ]
  }
}
```
"""
function candle(client::DeribitClient, query::CandleQuery)
    return APIsRequest{Data{CandleData}}("GET", "api/v2/public/get_tradingview_chart_data", query)(client)
end

function candle(client::DeribitClient = Deribit.Common.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
