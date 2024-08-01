module ContinuousCandle

export ContinuousCandleQuery,
    ContinuousCandleData,
    continuous_candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1

@enum ContractType PERPETUAL CURRENT_QUARTER NEXT_QUARTER

Base.@kwdef struct ContinuousCandleQuery <: BinancePublicQuery
    pair::String
    contractType::ContractType
    interval::TimeInterval
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:ContinuousCandleQuery}, x::TimeInterval)::String
    x == m1  && return "1m"
    x == m3  && return "3m"
    x == m5  && return "5m"
    x == m15 && return "15m"
    x == m30 && return "30m"
    x == h1  && return "1h"
    x == h2  && return "2h"
    x == h4  && return "4h"
    x == h6  && return "6h"
    x == h8  && return "8h"
    x == h12 && return "12h"
    x == d1  && return "1d"
    x == d3  && return "3d"
    x == w1  && return "1w"
    x == M1  && return "1M"
end

struct ContinuousCandleData <: BinanceData
    openTime::NanoDate
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    volume::Maybe{Float64}
    closeTime::NanoDate
    quoteAssetVolume::Maybe{Float64}
    tradesNumber::Maybe{Int64}
    takerBuyVolume::Maybe{Float64}
    takerBuyQuoteAssetVolume::Maybe{Float64}
end

"""
    continuous_candle(client::BinanceClient, query::ContinuousCandleQuery)
    continuous_candle(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

Kline/candlestick bars for a specific contract type.

[`GET fapi/v1/continuousKlines`](https://binance-docs.github.io/apidocs/futures/en/#continuous-contract-kline-candlestick-data)

## Parameters:

| Parameter    | Type           | Required | Description                                     |
|:-------------|:---------------|:---------|:------------------------------------------------|
| pair         | String         | true     |                                                 |
| contractType | ContractType   | true     | PERPETUAL CURRENT\\_QUARTER NEXT\\_QUARTER      |
| interval     | TimeInterval   | true     | m1 m3 m5 m15 m30 h1 h2 h4 h6 h8 h12 d1 d3 w1 M1 |
| endTime      | DateTime       | false    |                                                 |
| limit        | Int64          | false    |                                                 |
| startTime    | DateTime       | false    |   

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.USDMFutures.continuous_candle(;
    pair = "BTCUSDT",
    contractType = Binance.USDMFutures.ContinuousCandle.PERPETUAL,
    interval = Binance.USDMFutures.ContinuousCandle.M1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "openTime":"2019-09-01T00:00:00",
    "openPrice":8042.08,
    "highPrice":10475.54,
    "lowPrice":7700.67,
    "closePrice":8041.96,
    "volume":608742.1109999999,
    "closeTime":"2019-09-30T23:59:59.999000064",
    "quoteAssetVolume":5.61187924896223e9,
    "tradesNumber":998055,
    "takerBuyVolume":298326.244,
    "takerBuyQuoteAssetVolume":2.7368038906708302e9
  },
  ...
]
```
"""
function continuous_candle(client::BinanceClient, query::ContinuousCandleQuery)
    return APIsRequest{Vector{ContinuousCandleData}}("GET", "fapi/v1/continuousKlines", query)(client)
end

function continuous_candle(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return continuous_candle(client, ContinuousCandleQuery(; kw...))
end

end
