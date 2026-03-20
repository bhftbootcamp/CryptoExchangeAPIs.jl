module Candles

export CandlesQuery, candles

using Serde
using Dates, NanoDates
using EnumX

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category begin
    SPOT
    USDT_FUTURES
    COIN_FUTURES
    USDC_FUTURES
end

@enumx TimeInterval begin
    m1
    m3
    m5
    m15
    m30
    h1
    h4
    h6
    h12
    d1
    h6utc
    h12utc
    d1utc
end

@enumx CandlestickType market mark index premium

Base.@kwdef struct CandlesQuery <: BitgetPublicQuery
    category::Category.T
    symbol::String
    interval::TimeInterval.T
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    type::Maybe{CandlestickType.T} = nothing
    limit::Maybe{Int} = nothing
end

function Serde.SerQuery.ser_type(::Type{CandlesQuery}, x::Category.T)
    x == Category.SPOT && return "SPOT"
    x == Category.USDT_FUTURES && return "USDT-FUTURES"
    x == Category.COIN_FUTURES && return "COIN-FUTURES"
    x == Category.USDC_FUTURES && return "USDC-FUTURES"
end

function Serde.SerQuery.ser_type(::Type{CandlesQuery}, x::TimeInterval.T)
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1H"
    x == TimeInterval.h4  && return "4H"
    x == TimeInterval.h6  && return "6H"
    x == TimeInterval.h12 && return "12H"
    x == TimeInterval.d1  && return "1D"
    x == TimeInterval.h6utc  && return "6Hutc"
    x == TimeInterval.h12utc && return "12Hutc"
    x == TimeInterval.d1utc  && return "1Dutc"
end

struct CandleData <: BitgetData
    ts::NanoDate
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    baseVolume::Float64
    quoteVolume::Float64
end

"""
    candles(client::BitgetClient, query::CandlesQuery)
    candles(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Query kline/candlestick data. This endpoint allows retrieving up to 1,000 candlesticks.

[`GET /api/v3/market/candles`](https://www.bitget.com/api-doc/uta/public/Get-Candle-Data)

## Parameters:

| Parameter  | Type            | Required | Description                                    |
|:-----------|:----------------|:---------|:-----------------------------------------------|
| category   | Category        | true     | SPOT USDT-FUTURES COIN-FUTURES USDC-FUTURES    |
| symbol     | String          | true     | Symbol name (e.g. BTCUSDT).                    |
| interval   | TimeInterval    | true     | 1m 3m 5m 15m 30m 1H 4H 6H 12H 1D               |
| startTime  | Int             | false    | Start timestamp (Unix ms).                     |
| endTime    | Int             | false    | End timestamp (Unix ms).                       |
| type       | CandlestickType | false    | market, mark, index, premium. Default: market. |
| limit      | Int             | false    | Limit per page. Default 1000, max 100.         |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V3.Market.candles(;
    category = Bitget.API.V3.Market.Candles.Category.USDT_FUTURES,
    symbol = "BTCUSDT",
    interval = Bitget.API.V3.Market.Candles.TimeInterval.m1,
    limit = 10,
)
```
"""
function candles(client::BitgetClient, query::CandlesQuery)
    return APIsRequest{Data{Vector{CandleData}}}(
        "GET", "api/v3/market/candles", query
    )(client)
end

function candles(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return candles(client, CandlesQuery(; kw...))
end

end
