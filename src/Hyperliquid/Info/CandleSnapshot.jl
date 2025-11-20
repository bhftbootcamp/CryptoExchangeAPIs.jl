module CandleSnapshot

export CandleSnapshotQuery,
    CandleSnapshotData,
    CandleData,
    TimeInterval,
    candle_snapshot

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TimeInterval m1 m3 m5 m15 m30 h1 h2 h4 h8 h12 d1 d3 w1 M1

struct CandleReq <: HyperliquidData
    coin::String
    interval::TimeInterval.T
    startTime::DateTime
    endTime::Maybe{DateTime}
end

function Serde.SerJson.ser_type(::Type{CandleReq}, x::TimeInterval.T)::String
    x == TimeInterval.m1  && return "1m"
    x == TimeInterval.m3  && return "3m"
    x == TimeInterval.m5  && return "5m"
    x == TimeInterval.m15 && return "15m"
    x == TimeInterval.m30 && return "30m"
    x == TimeInterval.h1  && return "1h"
    x == TimeInterval.h2  && return "2h"
    x == TimeInterval.h4  && return "4h"
    x == TimeInterval.h8  && return "8h"
    x == TimeInterval.h12 && return "12h"
    x == TimeInterval.d1  && return "1d"
    x == TimeInterval.d3  && return "3d"
    x == TimeInterval.w1  && return "1w"
    x == TimeInterval.M1  && return "1M"
end

# Drop optional fields that are unset when serializing nested request payload
function Serde.SerJson.ser_ignore_field(::Type{CandleReq}, ::Val{:endTime}, x)::Bool
    return x === nothing
end

struct CandleSnapshotQuery <: HyperliquidPublicQuery
    type::String
    req::CandleReq
    
    function CandleSnapshotQuery(; req::CandleReq)
        new("candleSnapshot", req)
    end
end

struct CandleData <: HyperliquidData
    t::NanoDate  # Start time
    T::NanoDate  # End time
    s::String    # Symbol
    i::String    # Interval
    o::String    # Open
    c::String    # Close
    h::String    # High
    l::String    # Low
    v::String    # Volume
    n::Int       # Number of trades
end

const CandleSnapshotData = Vector{CandleData}

"""
    candle_snapshot(client::HyperliquidClient, query::CandleSnapshotQuery)
    candle_snapshot(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); 
                    coin::String, interval::TimeInterval.T, startTime::DateTime, endTime::Maybe{DateTime}=nothing)

Candle snapshot. Only the most recent 5000 candles are available.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#candle-snapshot)

## Parameters:

| Parameter | Type         | Required | Description                                                       |
|:----------|:-------------|:---------|:------------------------------------------------------------------|
| coin      | String       | true     | Coin name                                                         |
| interval  | TimeInterval | true     | m1 m3 m5 m15 m30 h1 h2 h4 h8 h12 d1 d3 w1 M1 (sent as "1m", ...) |
| startTime | DateTime     | true     | Start time (sent as milliseconds)                                 |
| endTime   | DateTime     | false    | End time (sent as milliseconds)                                   |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.candle_snapshot(;
    coin = "BTC",
    interval = Hyperliquid.Info.CandleSnapshot.TimeInterval.h1,
    startTime = DateTime("2023-04-19T15:00:00")
)

result = Hyperliquid.Info.candle_snapshot(;
    coin = "ETH",
    interval = Hyperliquid.Info.CandleSnapshot.TimeInterval.m15,
    startTime = DateTime("2023-04-19T15:00:00"),
    endTime = DateTime("2023-04-19T16:00:00")
)
```
"""
function candle_snapshot(client::HyperliquidClient, query::CandleSnapshotQuery)
    return APIsRequest{CandleSnapshotData}("POST", "info", query)(client)
end

function candle_snapshot(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    coin::String,
    interval::TimeInterval.T,
    startTime::DateTime,
    endTime::Maybe{DateTime} = nothing,
)
    req = CandleReq(coin, interval, startTime, endTime)
    return candle_snapshot(client, CandleSnapshotQuery(; req = req))
end

end
