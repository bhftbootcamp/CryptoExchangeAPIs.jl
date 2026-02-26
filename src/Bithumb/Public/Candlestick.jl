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

@enumx ChartInterval m1 m3 m5 m10 m15 m30 h1 h4 h6 h12 h24 w1 mm1

Base.@kwdef struct CandlestickQuery <: BithumbPublicQuery
    order_currency::String
    payment_currency::String
    chart_intervals::ChartInterval.T
end

function Serde.ser_type(::Type{<:CandlestickQuery}, x::ChartInterval.T)::String
    x == ChartInterval.m1  && return "1m"
    x == ChartInterval.m3  && return "3m"
    x == ChartInterval.m5  && return "5m"
    x == ChartInterval.m10 && return "10m"
    x == ChartInterval.m15 && return "15m"
    x == ChartInterval.m30 && return "30m"
    x == ChartInterval.h1  && return "1h"
    x == ChartInterval.h4  && return "4h"
    x == ChartInterval.h6  && return "6h"
    x == ChartInterval.h12 && return "12h"
    x == ChartInterval.h24 && return "24h"
    x == ChartInterval.w1  && return "1w"
    x == ChartInterval.mm1 && return "1mm"
end

Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:order_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:payment_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{CandlestickQuery}, ::Val{:chart_intervals}) = true

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
    candlestick(client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config); kw...)

Provides virtual asset price and trading volume information by time and section.

[`GET public/candlestick/{order_currency}_{payment_currency}/{chart_intervals}`](https://apidocs.bithumb.com/reference/candlestick-rest-api)

## Parameters:

| Parameter        | Type          | Required | Description                    |
|:-----------------|:--------------|:---------|:-------------------------------|
| order_currency   | String        | true     |                                |
| payment_currency | String        | true     |                                |
| chart_intervals  | ChartInterval | true     | m1 m3 m5 m10 m15 m30 h1 h4 h6 h12 h24 w1 mm1 |

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.Public.Candlestick.candlestick(;
    order_currency = "BTC",
    payment_currency = "KRW",
    chart_intervals = Bithumb.Public.Candlestick.ChartInterval.h24,
)
```
"""
function candlestick(client::BithumbClient, query::CandlestickQuery)
    chart_intervals = Serde.SerQuery.ser_type(CandlestickQuery, query.chart_intervals)
    return APIsRequest{Data{Vector{CandlestickData}}}(
        "GET", "public/candlestick/$(query.order_currency)_$(query.payment_currency)/$(chart_intervals)",
        query,
    )(client)
end

function candlestick(
    client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config);
    kw...,
)
    return candlestick(client, CandlestickQuery(; kw...))
end

end
