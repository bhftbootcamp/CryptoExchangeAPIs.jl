module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
end

struct TickerData <: BinanceData
    closeTime::NanoDate
    count::Int64
    firstId::Int64
    highPrice::Float64
    lastId::Int64
    lastPrice::Float64
    lastQty::Float64
    lowPrice::Float64
    openPrice::Float64
    openTime::NanoDate
    priceChange::Float64
    priceChangePercent::Float64
    quoteVolume::Float64
    symbol::String
    volume::Float64
    weightedAvgPrice::Float64
end

"""
    ticker(client::BinanceClient, query::TickerQuery)
    ticker(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

24 hour rolling window price change statistics.

[`GET fapi/v1/ticker/24hr`](https://binance-docs.github.io/apidocs/futures/en/#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.ticker(;
    symbol = "ADAUSDT",
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "closeTime":"2024-03-21T21:40:44.384999936",
  "count":952934,
  "firstId":1090483662,
  "highPrice":0.649,
  "lastId":1091436596,
  "lastPrice":0.631,
  "lastQty":1000.0,
  "lowPrice":0.6182,
  "openPrice":0.6389,
  "openTime":"2024-03-20T21:40:00",
  "priceChange":-0.0079,
  "priceChangePercent":-1.237,
  "quoteVolume":4.378010427731e8,
  "symbol":"ADAUSDT",
  "volume":6.89939719e8,
  "weightedAvgPrice":0.63455
}
```
"""
function ticker(client::BinanceClient, query::TickerQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{TickerData}}("GET", "fapi/v1/ticker/24hr", query)(client)
    else
        APIsRequest{TickerData}("GET", "fapi/v1/ticker/24hr", query)(client)
    end
end

function ticker(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end