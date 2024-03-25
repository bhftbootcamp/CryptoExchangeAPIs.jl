module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: UpbitPublicQuery
    markets::Union{Vector{String},String}
end

function Serde.SerQuery.ser_type(::Type{TickerQuery}, x::Vector{String})::String
    return "[\"" * join(x, "\",\"") * "\"]"
end

struct TickerData <: UpbitData
    acc_trade_price::Maybe{Float64}
    acc_trade_price_24h::Maybe{Float64}
    acc_trade_volume::Maybe{Float64}
    acc_trade_volume_24h::Maybe{Float64}
    change::Maybe{String}
    change_price::Maybe{Float64}
    change_rate::Maybe{Float64}
    high_price::Maybe{Float64}
    highest_52_week_date::Maybe{Date}
    highest_52_week_price::Maybe{Float64}
    low_price::Maybe{Float64}
    lowest_52_week_date::Maybe{Date}
    lowest_52_week_price::Maybe{Float64}
    market::String
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    signed_change_price::Maybe{Float64}
    signed_change_rate::Maybe{Float64}
    timestamp::Maybe{NanoDate}
    trade_date::Maybe{Date}
    trade_date_kst::Maybe{Date}
    trade_price::Maybe{Float64}
    trade_time::Maybe{Time}
    trade_time_kst::Maybe{Time}
    trade_timestamp::Maybe{NanoDate}
    trade_volume::Maybe{Float64}
end

"""
    ticker(client::UpbitClient, query::TickerQuery)
    ticker(client::UpbitClient = Upbit.Spot.public_client; kw...)

Returns a snapshot of the stock at the time of the request

[`GET v1/ticker`](https://docs.upbit.com/reference/ticker현재가-정보)

## Parameters:

| Parameter | Type                     | Required | Description |
|:----------|:-------------------------|:---------|:------------|
| markets   | String OR Vector{String} | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Upbit

result = Upbit.Spot.ticker(;
    markets = "KRW-BTC"
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "acc_trade_price":2.1238782327620905e11,
    "acc_trade_price_24h":4.622074226861333e11,
    "acc_trade_volume":2206.86731219,
    "acc_trade_volume_24h":4823.01685822,
    "change":"FALL",
    "change_price":544000.0,
    "change_rate":0.0056300712,
    "high_price":9.7e7,
    "highest_52_week_date":"2024-03-14",
    "highest_52_week_price":1.05e8,
    "low_price":9.56e7,
    "lowest_52_week_date":"2023-06-15",
    "lowest_52_week_price":3.251e7,
    "market":"KRW-BTC",
    "opening_price":9.6624e7,
    "prev_closing_price":9.6624e7,
    "signed_change_price":-544000.0,
    "signed_change_rate":-0.0056300712,
    "timestamp":"2024-03-25T10:53:39.956999936",
    "trade_date":"2024-03-25",
    "trade_date_kst":"2024-03-25",
    "trade_price":9.608e7,
    "trade_time":"10:53:39",
    "trade_time_kst":"19:53:39",
    "trade_timestamp":"2024-03-25T10:53:39.924",
    "trade_volume":0.0198534
  }
]
```
"""
function ticker(client::UpbitClient, query::TickerQuery)
    return APIsRequest{Vector{TickerData}}("GET", "v1/ticker", query)(client)
end

function ticker(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
