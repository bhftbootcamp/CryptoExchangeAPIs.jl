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

function Serde.SerQuery.ser_type(::Type{TickerQuery}, x::Vector{String},)::String
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

| Parameter | Type                   | Required | Description |
|:----------|:-----------------------|:---------|:------------|
| markets   | Vector{String},String) | true     |             |

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
    "market": "KRW-BTC",
    "trade_date": "20180418",
    "trade_time": "102340",
    "trade_date_kst": "20180418",
    "trade_time_kst": "192340",
    "trade_timestamp": 1524047020000,
    "opening_price": 8450000,
    "high_price": 8679000,
    "low_price": 8445000,
    "trade_price": 8621000,
    "prev_closing_price": 8450000,
    "change": "RISE",
    "change_price": 171000,
    "change_rate": 0.0202366864,
    "signed_change_price": 171000,
    "signed_change_rate": 0.0202366864,
    "trade_volume": 0.02467802,
    "acc_trade_price": 108024804862.58253,
    "acc_trade_price_24h": 232702901371.09308,
    "acc_trade_volume": 12603.53386105,
    "acc_trade_volume_24h": 27181.31137002,
    "highest_52_week_price": 28885000,
    "highest_52_week_date": "2018-01-06",
    "lowest_52_week_price": 4175000,
    "lowest_52_week_date": "2017-09-25",
    "timestamp": 1524047026072
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
