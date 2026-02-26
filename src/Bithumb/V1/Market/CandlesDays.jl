module CandlesDays

export CandlesDaysQuery,
    CandleDayData,
    candles_days

using Serde
using Dates, NanoDates

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CandlesDaysQuery <: BithumbPublicQuery
    market::String
    to::Maybe{DateTime} = nothing
    count::Maybe{Int} = nothing
    convertingPriceUnit::Maybe{String} = nothing
end

Serde.SerQuery.ser_type(::Type{<:CandlesDaysQuery}, x::DateTime) = Dates.format(x, "yyyy-mm-ddTHH:MM:SS")

struct CandleDayData <: BithumbData
    market::String
    candle_date_time_utc::DateTime
    candle_date_time_kst::DateTime
    opening_price::Float64
    high_price::Float64
    low_price::Float64
    trade_price::Float64
    timestamp::NanoDate
    candle_acc_trade_price::Float64
    candle_acc_trade_volume::Float64
    prev_closing_price::Float64
    change_price::Float64
    change_rate::Float64
end

"""
    candles_days(client::BithumbClient, query::CandlesDaysQuery)
    candles_days(client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config); kw...)

Get day (일) candlestick data.

[`GET v1/candles/days`](https://apidocs.bithumb.com/reference/일day-캔들)

## Parameters:

| Parameter | Type     | Required | Description                            |
|:----------|:---------|:---------|:---------------------------------------|
| market    | String   | true     | Market code (e.g. `\"KRW-BTC\"`)       |
| to        | DateTime | false    | Last candle time (exclusive)           |
| count     | Int      | false    | Number of candles (default 1, max 200) |

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.V1.Market.candles_days(;
    market = "KRW-BTC",
    count = 100,
)
```
"""
function candles_days(client::BithumbClient, query::CandlesDaysQuery)
    return APIsRequest{Vector{CandleDayData}}("GET", "v1/candles/days", query)(client)
end

function candles_days(
    client::BithumbClient = Bithumb.BithumbClient(Bithumb.public_config);
    kw...,
)
    return candles_days(client, CandlesDaysQuery(; kw...))
end

end
