module Candle

export CandleQuery,
    CandleData,
    candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs.Bithumb: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m10 m30 h1 h6 h12 h24

Base.@kwdef struct CandleQuery <: BithumbPublicQuery
    order_currency::String
    payment_currency::String
    interval::TimeInterval
end

function Serde.ser_type(::Type{<:CandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m3  && return "3m"
    x == m5  && return "5m"
    x == m10 && return "10m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h6  && return "6h"
    x == h12 && return "12h"
    x == h24  && return "24h"
end

Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:order_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:payment_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandleQuery}, ::Val{:interval}) = true

struct CandleData <: BithumbData
    timestamp::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    vol::Maybe{Float64}
end

"""
    candle(client::BithumbClient, query::CandleQuery)
    candle(client::BithumbClient = Bithumb.Spot.public_client; kw...)

Provides virtual asset price and trading volume information by time and section.

[`GET public/candlestick/{order_currency}_{payment_currency}/{chart_intervals}`](https://apidocs.bithumb.com/reference/candlestick-rest-api)

## Parameters:

| Parameter        | Type         | Required | Description                    |
|:-----------------|:-------------|:---------|:-------------------------------|
| order_currency   | String       | true     |                                |
| payment_currency | String       | true     |                                |
| interval         | TimeInterval | true     | m1 m3 m5 m10 m30 h1 h6 h12 h24 |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bithumb

result = Bithumb.Spot.candle(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = Bithumb.Spot.Candle.h24,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"0000",
  "date":null,
  "data":[
    {
      "timestamp":"2024-05-14T15:00:00",
      "open":8.6639e7,
      "close":8.6419e7,
      "high":8.6845e7,
      "low":8.575e7,
      "vol":216.48937355
    },
    ...
  ]
}
```
"""
function candle(client::BithumbClient, query::CandleQuery)
    timeframe = Serde.SerQuery.ser_type(CandleQuery, query.interval)
    return APIsRequest{Data{Vector{CandleData}}}("GET", "public/candlestick/$(query.order_currency)_$(query.payment_currency)/$timeframe", query)(client)
end

function candle(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return candle(client, CandleQuery(; kw...))
end

end
