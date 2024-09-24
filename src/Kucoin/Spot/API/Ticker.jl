module Ticker

export TickerQuery, 
    TickerAllQuery,
    TickerData,
    TickerAllData,
    ticker,
    ticker_all

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: KucoinPublicQuery
    symbol::Maybe{String}
end

Base.@kwdef struct TickerAllQuery <: KucoinPublicQuery
    #__ empty
end

struct TickerData <: KucoinData
    symbol::String
    averagePrice::Maybe{Float64}
    buy::Maybe{Float64}
    changePrice::Maybe{Float64}
    changeRate::Maybe{Float64}
    high::Maybe{Float64}
    last::Maybe{Float64}
    low::Maybe{Float64}
    makerCoefficient::Maybe{Float64}
    makerFeeRate::Maybe{Float64}
    sell::Maybe{Float64}
    takerCoefficient::Maybe{Float64}
    takerFeeRate::Maybe{Float64}
    time::Maybe{NanoDate}
    vol::Maybe{Float64}
    volValue::Maybe{Float64}
end

struct TickerAllData <: KucoinData
    time::Maybe{NanoDate}
    ticker::Vector{TickerData}
end

"""
    ticker(client::KucoinClient, query::TickerQuery)
    ticker(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request via this endpoint to get the statistics of the specified ticker in the last 24 hours.
    
[`GET api/v1/market/stats`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-24hr-stats)

## Parameters:

| Parameter  | Type   | Required | Description |
|:-----------|:-------|:---------|:------------|
| symbol     | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.ticker(; symbol = "BTC")

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200000,
  "data":{
    "symbol":"BTC",
    "averagePrice":null,
    "buy":null,
    "changePrice":null,
    "changeRate":null,
    "high":null,
    "last":null,
    "low":null,
    "makerCoefficient":null,
    "makerFeeRate":null,
    "sell":null,
    "takerCoefficient":null,
    "takerFeeRate":null,
    "time":"2024-09-23T15:48:26.456999936",
    "vol":null,
    "volValue":null
  }
}
```
"""
function ticker(client::KucoinClient, query::TickerQuery)
    return APIsRequest{Data{TickerData}}("GET", "api/v1/market/stats", query)(client)
end

function ticker(client::KucoinClient = Kucoin.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

"""
    ticker_all(client::KucoinClient, query::TickerQuery)
    ticker_all(client::KucoinClient = Kucoin.Spot.public_client; kw...)

Request market tickers for all the trading pairs in the market (including 24h volume).
    
[`GET api/v1/market/allTickers`](https://www.kucoin.com/docs/rest/spot-trading/market-data/get-all-tickers)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Spot.ticker_all()

to_pretty_json(result.result)
```

## Result:

```json
{
"code":200000,
  "data":{
    "time":"2024-09-23T15:54:48.020999936",
    "ticker":[
      {
        "symbol":"HLG-USDT",
        "averagePrice":0.0015635,
        "buy":0.00156,
        "changePrice":3.0e-5,
        "changeRate":0.0194,
        "high":0.00161,
        "last":0.00157,
        "low":0.00152,
        "makerCoefficient":2.0,
        "makerFeeRate":0.001,
        "sell":0.00158,
        "takerCoefficient":2.0,
        "takerFeeRate":0.001,
        "time":null,
        "vol":1.6744577e6,
        "volValue":2626.113078
      },
      ...
      ]
    }
}
```
"""
function ticker_all(client::KucoinClient, query::TickerAllQuery)
    return APIsRequest{Data{TickerAllData}}("GET", "api/v1/market/allTickers", query)(client)
end

function ticker_all(client::KucoinClient = Kucoin.Spot.public_client; kw...)
    return ticker_all(client, TickerAllQuery(; kw...))
end

end