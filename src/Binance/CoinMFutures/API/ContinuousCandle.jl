module ContinuousCandle

export ContinuousCandleQuery,
    ContinuousCandleData,
    continuous_candle

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

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
    baseAssetVolume::Maybe{Float64}
    tradesNumber::Maybe{Int64}
    takerBuyVolume::Maybe{Float64}
    takerBuyBaseAssetVolume::Maybe{Float64}
end

"""
    continuous_candle(client::BinanceClient, query::ContinuousCandleQuery)
    continuous_candle(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)

Kline/candlestick bars for a specific contract type.

[`GET dapi/v1/continuousKlines`](https://binance-docs.github.io/apidocs/delivery/en/#continuous-contract-kline-candlestick-data)

## Parameters:

| Parameter    | Type           | Required | Description                              |
|:-------------|:---------------|:---------|:-----------------------------------------|
| pair         | String         | true     |                                          |
| contractType | ContractType   | true     | PERPETUAL, CURRENT_QUARTER, NEXT_QUARTER |
| interval     | TimeInterval   | true     |                                          |
| endTime      | DateTime       | false    |                                          |
| limit        | Int64          | false    |                                          |
| startTime    | DateTime       | false    |                                          |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance.CoinMFutures.ContinuousCandle

result = Binance.CoinMFutures.continuous_candle(;
    pair = "BTCUSD",
    contractType = Binance.CoinMFutures.ContinuousCandle.PERPETUAL,
    interval = Binance.CoinMFutures.ContinuousCandle.M1,
)

to_pretty_json(result.result)
```

## Result:

```json
       
{
    "openTime":"2023-10-01T00:00:00",
    "openPrice":26957.3,
    "highPrice":35811.9,
    "lowPrice":26516.7,
    "closePrice":34679.8,
    "volume":4.49110256e8,
    "closeTime":"2023-10-31T23:59:59.999000064",
    "baseAssetVolume":1.50363571181441e6,
    "tradesNumber":11775107,
    "takerBuyVolume":2.24708613e8,
    "takerBuyBaseAssetVolume":752475.86725638
  },
  ...
]
```
"""
function continuous_candle(client::BinanceClient, query::ContinuousCandleQuery)
    return APIsRequest{Vector{ContinuousCandleData}}("GET", "dapi/v1/continuousKlines", query)(client)
end

function continuous_candle(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return continuous_candle(client, ContinuousCandleQuery(; kw...))
end

end

using Serde
using CryptoAPIs.Binance.CoinMFutures.ContinuousCandle

result = Binance.CoinMFutures.continuous_candle(;
    pair = "BTCUSD",
    contractType = Binance.CoinMFutures.ContinuousCandle.PERPETUAL,
    interval = Binance.CoinMFutures.ContinuousCandle.M1,
)

to_pretty_json(result.result)