module Candles

export CandlesQuery,
    CandleData,
    candles

using Serde
using EnumX
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Granularity begin
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
    d3
    w1
    M1
    h6utc
    h12utc
    d1utc
    d3utc
    w1utc
    M1utc
end

Base.@kwdef struct CandlesQuery <: BitgetPublicQuery
    symbol::String
    granularity::Granularity.T
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int} = nothing
end

function Serde.SerQuery.ser_type(::Type{CandlesQuery}, x::Granularity.T)
    x == Granularity.m1  && return "1min"
    x == Granularity.m3  && return "3min"
    x == Granularity.m5  && return "5min"
    x == Granularity.m15 && return "15min"
    x == Granularity.m30 && return "30min"
    x == Granularity.h1  && return "1h"
    x == Granularity.h4  && return "4h"
    x == Granularity.h6  && return "6h"
    x == Granularity.h12 && return "12h"
    x == Granularity.d1  && return "1day"
    x == Granularity.d3  && return "3day"
    x == Granularity.w1  && return "1week"
    x == Granularity.M1  && return "1M"
    x == Granularity.h6utc  && return "6Hutc"
    x == Granularity.h12utc && return "12Hutc"
    x == Granularity.d1utc  && return "1Dutc"
    x == Granularity.d3utc  && return "3Dutc"
    x == Granularity.w1utc  && return "1Wutc"
    x == Granularity.M1utc  && return "1Mutc"
end

struct CandleData <: BitgetData
    ts::NanoDate
    open::Float64
    high::Float64
    low::Float64
    close::Float64
    baseVolume::Float64
    usdtVolume::Float64
    quoteVolume::Float64
end

"""
    candles(client::BitgetClient, query::CandlesQuery)
    candles(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get candlestick data.

[`GET api/v2/spot/market/candles`](https://www.bitget.com/api-doc/classic/spot/market/Get-Candle-Data)

## Parameters:

| Parameter   | Type        | Required | Description                                                                 |
|:------------|:------------|:---------|:----------------------------------------------------------------------------|
| symbol      | String      | true     | Trading pair (e.g. `\"BTCUSDT\"`).                                          |
| granularity | Granularity | true     | m1 m3 m5 m15 m30 h1 h4 h6 h12 d1 d3 w1 M1                                   |
| startTime   | DateTime    | false    | Start time (Unix ms).                                                       |
| endTime     | DateTime    | false    | End time (Unix ms).                                                         |
| limit       | Int         | false    | Number of results; default 100, max 1000.                                   |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V2.Spot.Market.candles(
    symbol = "BTCUSDT",
    granularity = Bitget.API.V2.Spot.Market.Candles.Granularity.m1,
    limit = 100,
)
```
"""
function candles(client::BitgetClient, query::CandlesQuery)
    return APIsRequest{Data{Vector{CandleData}}}("GET", "api/v2/spot/market/candles", query)(client)
end

function candles(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return candles(client, CandlesQuery(; kw...))
end

end
