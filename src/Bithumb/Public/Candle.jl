module Candlestick

export CandlestickQuery,
    CandlestickData,
    candlestick

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs.Bithumb: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m10 m30 h1 h6 h12 h24

Base.@kwdef struct CandlestickQuery <: BithumbPublicQuery
    order_currency::String
    payment_currency::String
    interval::TimeInterval.T
end

function Serde.ser_type(::Type{<:CandlestickQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m10 && return "10m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h6  && return "6h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.h24 && return "24h"
end

Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:order_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:payment_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:interval}) = true

struct CandlestickData <: BithumbData
    timestamp::NanoDate
    open::Maybe{Float64}
    close::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    vol::Maybe{Float64}
end

"""
    candlestick(client::BithumbClient, query::CandlestickQuery)
    candlestick(client::BithumbClient = Bithumb.Spot.public_client; kw...)

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

result = Bithumb.Spot.candlestick(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = Bithumb.Spot.Candlestick.h24,
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
function candlestick(client::BithumbClient, query::CandlestickQuery)
    timeframe = Serde.SerQuery.ser_type(CandlestickQuery, query.interval)
    return APIsRequest{Data{Vector{CandlestickData}}}("GET", "public/candlestick/$(query.order_currency)_$(query.payment_currency)/$timeframe", query)(client)
end

function candlestick(client::BithumbClient = Bithumb.public_client; kw...)
    return candlestick(client, CandlestickQuery(; kw...))
end

end
