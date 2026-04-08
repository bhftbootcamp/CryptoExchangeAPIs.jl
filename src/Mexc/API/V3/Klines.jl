module Klines

export KlinesQuery,
    KlinesData,
    klines

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest
using EnumX

@enumx TimeInterval m1 m5 m15 m30 m60 h4 h8 d1 w1 M1

Base.@kwdef struct KlinesQuery <: MexcPublicQuery
    symbol::String
    interval::TimeInterval.T
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

function Serde.ser_type(::Type{<:KlinesQuery}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.m60 && return "60m"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.w1  && return "1W"
    x == TimeInterval.M1  && return "1M"
end

struct KlinesData <: MexcData
    openTime::Maybe{NanoDate}
    openPrice::Maybe{Float64}
    highPrice::Maybe{Float64}
    lowPrice::Maybe{Float64}
    closePrice::Maybe{Float64}
    volume::Maybe{Float64}
    closeTime::NanoDate
    quoteAssetVolume::Maybe{Float64}
end

"""
    klines(client::MexcClient, query::KlinesQuery)
    klines(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)

Kline/candlestick bars for a symbol.

[`GET api/v3/klines`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#kline-candlestick-data)

## Parameters:

| Parameter | Type         | Required | Description                                  |
|:----------|:-------------|:---------|:---------------------------------------------|
| symbol    | String       | true     |                                              |
| interval  | TimeInterval | true     | m1 m5 m15 m30 m60 h4 h8 d1 w1 M1            |
| endTime   | DateTime     | false    |                                              |
| limit     | Int64        | false    | Default 500; max 1000                        |
| startTime | DateTime     | false    |                                              |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.klines(;
    symbol = "BTCUSDT",
    interval = Mexc.API.V3.Klines.TimeInterval.d1,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "openTime":"2024-01-01T00:00:00",
    "openPrice":42283.36,
    "highPrice":42500.01,
    "lowPrice":42100.50,
    "closePrice":42436.10,
    "volume":1732.461487,
    "closeTime":"2024-01-01T23:59:59.999000064",
    "quoteAssetVolume":168387.3
  },
  ...
]
```
"""
function klines(client::MexcClient, query::KlinesQuery)
    return APIsRequest{Vector{KlinesData}}("GET", "api/v3/klines", query)(client)
end

function klines(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)
    return klines(client, KlinesQuery(; kw...))
end

end
