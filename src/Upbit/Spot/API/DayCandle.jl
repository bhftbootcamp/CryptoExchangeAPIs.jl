module DayCandle

export DayCandleQuery,
    DayCandleData, 
    daily_candle

using Serde
using Dates, ManoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct DayCandleQuery <: UpbitPublicQuery
    market::String
    convertingPriceUnit::Maybe{String} = nothing
    count::Maybe{Int64} = nothing                  # Count of candles (LIMIT : 200)
    to::Maybe{DateTime} = nothing
end

struct DayCandleData <: UpbitData
    candle_acc_trade_price::Maybe{Float64}
    candle_acc_trade_volume::Maybe{Float64}
    candle_date_time_kst::Maybe{NanoDate}
    candle_date_time_utc::Maybe{NanoDate}
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    high_price::Maybe{Float64}
    low_price::Maybe{Float64}
    market::Maybe{String}
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    timestamp::Maybe{NanoDate}
    trade_price::Maybe{Float64}
end

"""
    daily_candle(client::UpbitClient, query::DayCandleQuery)
    daily_candle(client::UpbitClient = Upbit.Spot.public_client; kw...)

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

result = Upbit.Spot.daily_candle(;
    market = "KRW-BTC"
) 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market": "KRW-BTC",
    "candle_date_time_utc": "2018-04-18T00:00:00",
    "candle_date_time_kst": "2018-04-18T09:00:00",
    "opening_price": 8450000,
    "high_price": 8679000,
    "low_price": 8445000,
    "trade_price": 8626000,
    "timestamp": 1524046650532,
    "candle_acc_trade_price": 107184005903.68721,
    "candle_acc_trade_volume": 12505.93101659,
    "prev_closing_price": 8450000,
    "change_price": 176000,
    "change_rate": 0.0208284024
  }
]
```
"""
function daily_candle(client::UpbitClient, query::DayCandleQuery)
    return APIsRequest{Vector{DayCandleData}}("GET", "v1/candles/days", query)(client)
end

function daily_candle(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return daily_candle(client, DayCandleQuery(; kw...))
end

end