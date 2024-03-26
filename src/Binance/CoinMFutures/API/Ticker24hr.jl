module Ticker24hr

export Ticker24hrQuery,
    Ticker24hrData,
    ticker_24hr

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct Ticker24hrQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
    pair::Maybe{String} = nothing
end

struct Ticker24hrData <: BinanceData
    symbol::String
    pair::String
    pricechange::Maybe{Float64}
    pricechangePercent::Maybe{Float64}
    weightedAvgPrice::Maybe{Float64}
    lastPrice::Maybe{Float64}
    lastQty::Maybe{Int64}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    volume::Maybe{Int64}
    baseVolume::Maybe{Float64}
    openTime::NanoDate
    closeTime::NanoDate
    firstId::Maybe{Int64}
    lastId::Maybe{Int64}
    count::Maybe{Int64}
end

"""
    ticker_24hr(client::BinanceClient, query::Ticker24hrQuery)
    ticker_24hr(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)


[`GET dapi/v1/ticker/24hr`](https://binance-docs.github.io/apidocs/delivery/en/#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |
| pair      | String   | false    |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.Binance.CoinMFutures.Ticker24hr

result = ticker_24hr(;
    pair = "BTCUSD",
)

to_pretty_json(result.result)
```

## Result:

```json
[
 {
    "symbol":"BTCUSD_240329",
    "pair":"BTCUSD",
    "pricechange":null,
    "pricechangePercent":null,
    "weightedAvgPrice":70683.35523318,
    "lastPrice":70261.6,
    "lastQty":11,
    "openPrice":71004.7,
    "highPrice":71750.0,
    "lowPrice":69500.4,
    "volume":1027906,
    "baseVolume":1454.24053033,
    "openTime":"2024-03-25T19:03:00",
    "closeTime":"2024-03-26T19:03:03.286000128",
    "firstId":7968276,
    "lastId":8038563,
    "count":70288
  },
  ...
]
```
"""
function ticker_24hr(client::BinanceClient, query::Ticker24hrQuery)
    return APIsRequest{Vector{Ticker24hrData}}("GET", "/dapi/v1/ticker/24hr", query)(client)
end

function ticker_24hr(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return ticker_24hr(client, Ticker24hrQuery(; kw...))
end

end