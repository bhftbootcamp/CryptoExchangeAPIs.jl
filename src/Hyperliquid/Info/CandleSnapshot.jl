module CandleSnapshot

export CandleSnapshotQuery,
    CandleSnapshotData,
    CandleData,
    candle_snapshot

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct CandleReq <: HyperliquidData
    coin::String
    interval::String
    startTime::Int
    endTime::Maybe{Int}
end

Base.@kwdef struct CandleSnapshotQuery <: HyperliquidPublicQuery
    type::String = "candleSnapshot"
    req::CandleReq
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
                    coin::String, interval::String, startTime::Int, endTime::Maybe{Int}=nothing)

Candle snapshot. Only the most recent 5000 candles are available.

Supported intervals: "1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h", "8h", "12h", "1d", "3d", "1w", "1M"

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#candle-snapshot)

## Parameters:

| Parameter | Type   | Required | Description                        |
|:----------|:-------|:---------|:-----------------------------------|
| coin      | String | true     | Coin name                          |
| interval  | String | true     | Candle interval                    |
| startTime | Int    | true     | Start time in epoch milliseconds   |
| endTime   | Int    | false    | End time in epoch milliseconds     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.candle_snapshot(;
    coin = "BTC",
    interval = "1h",
    startTime = 1681923600000
)

result = Hyperliquid.Info.candle_snapshot(;
    coin = "ETH",
    interval = "15m",
    startTime = 1681923600000,
    endTime = 1681924499999
)
```
"""
function candle_snapshot(client::HyperliquidClient, query::CandleSnapshotQuery)
    return APIsRequest{CandleSnapshotData}("POST", "info", query)(client)
end

function candle_snapshot(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    coin::String,
    interval::String,
    startTime::Int,
    endTime::Maybe{Int} = nothing,
)
    req = CandleReq(coin, interval, startTime, endTime)
    return candle_snapshot(client, CandleSnapshotQuery(; req = req))
end

end

