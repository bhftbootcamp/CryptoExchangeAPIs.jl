module DayCandle

export DayCandleQuery,
    DayCandleData, 
    day_candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct DayCandleQuery <: UpbitPublicQuery
    market::String
    convertingPriceUnit::Maybe{String} = nothing
    count::Maybe{Int64} = nothing                  # Count of candles (LIMIT : 200)
    to::Maybe{DateTime} = nothing
end

struct DayCandleData <: UpbitData
    market::Maybe{String}
    candle_acc_trade_price::Maybe{Float64}
    candle_acc_trade_volume::Maybe{Float64}
    candle_date_time_kst::Maybe{NanoDate}
    candle_date_time_utc::Maybe{NanoDate}
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    timestamp::Maybe{NanoDate}
    trade_price::Maybe{Float64}
end

"""
    day_candle(client::UpbitClient, query::DayCandleQuery)
    day_candle(client::UpbitClient = Upbit.Spot.public_client; kw...)

Daily candle data.

[`GET v1/candles/days`](https://docs.upbit.com/reference/일day-캔들-1)

## Parameters:

| Parameter           | Type     | Required | Description |
|:--------------------|:---------|:---------|:------------|
| market              | String   | true     |             |
| convertingPriceUnit | String   | false    |             |
| count               | Int64    | false    |             |
| to                  | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Upbit

result = Upbit.Spot.day_candle(;
    market = "KRW-BTC"
) 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market":"KRW-BTC",
    "candle_acc_trade_price":2.0574363150768314e11,
    "candle_acc_trade_volume":2137.74569241,
    "candle_date_time_kst":"2024-03-25T09:00:00",
    "candle_date_time_utc":"2024-03-25T00:00:00",
    "change_price":-419000.0,
    "change_rate":-0.0043363968,
    "high_price":9.7e7,
    "low_price":9.56e7,
    "opening_price":9.6624e7,
    "prev_closing_price":9.6624e7,
    "timestamp":"2024-03-25T10:22:43.660999936",
    "trade_price":9.6205e7
  }
]
```
"""
function day_candle(client::UpbitClient, query::DayCandleQuery)
    return APIsRequest{Vector{DayCandleData}}("GET", "v1/candles/days", query)(client)
end

function day_candle(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return day_candle(client, DayCandleQuery(; kw...))
end

end