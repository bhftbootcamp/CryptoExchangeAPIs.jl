module HistoryCandles

export HistoryCandlesQuery,
    HistoryCandlesData,
    history_candles

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3

Base.@kwdef struct HistoryCandlesQuery <: OkxPublicQuery
    instId::String
    after::Maybe{DateTime} = nothing
    bar::Maybe{TimeInterval.T} = nothing
    before::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

function Serde.ser_type(::Type{<:HistoryCandlesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1H"
    x == TimeInterval.h2  && return "2H"
    x == TimeInterval.h4  && return "4H"
    x == TimeInterval.h6  && return "6Hutc"
    x == TimeInterval.h12 && return "12Hutc"
    x == TimeInterval.d1  && return "1Dutc"
    x == TimeInterval.d2  && return "2Dutc"
    x == TimeInterval.d3  && return "3Dutc"
    x == TimeInterval.w1  && return "1Wutc"
    x == TimeInterval.M1  && return "1Mutc"
    x == TimeInterval.M3  && return "3Mutc"
end

struct HistoryCandlesData <: OkxData
    openTime::Maybe{NanoDate}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    vol::Maybe{Float64}
    volCcy::Maybe{Float64}
    volCcyQuote::Maybe{Float64}
    confirm::Maybe{Int64}
end

"""
    history_candles(client::OkxClient, query::HistoryCandlesQuery)
    history_candles(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

Retrieve history candlestick charts from recent years.

[`GET api/v5/market/history-candles`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-candlesticks-history)

## Parameters:

| Parameter | Type         | Required | Description                                        |
|:----------|:-------------|:---------|:---------------------------------------------------|
| instId    | String       | true     |                                                    |
| after     | DateTime     | false    |                                                    |
| bar       | TimeInterval | false    | m1 m3 m5 m15 m30 h1 h2 h4 h6 h12 d1 d2 d3 w1 M1 M3 |
| before    | DateTime     | false    |                                                    |
| limit     | Int64        | false    |                                                    |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Market.history_candles(;
    instId = "BTC-USDT",
    bar = Okx.API.V5.Market.HistoryCandles.TimeInterval.d1,
)
```
"""
function history_candles(client::OkxClient, query::HistoryCandlesQuery)
    return APIsRequest{Data{HistoryCandlesData}}("GET", "api/v5/market/history-candles", query)(client)
end

function history_candles(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return history_candles(client, HistoryCandlesQuery(; kw...))
end

end
