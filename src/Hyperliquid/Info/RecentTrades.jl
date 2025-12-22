module RecentTrades

export RecentTradesQuery,
    RecentTradesData,
    recent_trades

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TradeSide sell buy

struct RecentTradesQuery <: HyperliquidPublicQuery
    type::String
    coin::String
    function RecentTradesQuery(; coin::String)
        new("recentTrades", coin)
    end
end

struct RecentTradesEntry <: HyperliquidData
    coin::String
    side::TradeSide.T
    px::Float64
    sz::Float64
    time::NanoDate
    hash::String
    tid::Int64
    users::Vector{String}
end

function Serde.deser(::Type{RecentTradesEntry}, ::Type{TradeSide.T}, x::String)
    x == "A" && return TradeSide.sell
    x == "B" && return TradeSide.buy
    throw(ArgumentError("Invalid trade side: $x"))
end

"""
    recent_trades(client::HyperliquidClient, query::RecentTradesQuery)
    recent_trades(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve the most recent public trades for a specific asset.

[`POST /info`](https://docs.chainstack.com/reference/hyperliquid-info-recent-trades)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| coin      | String | true     |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.recent_trades(; coin = "BTC")
```
"""
function recent_trades(client::HyperliquidClient, query::RecentTradesQuery)
    return APIsRequest{Vector{RecentTradesEntry}}("POST", "info", query)(client)
end

function recent_trades(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return recent_trades(client, RecentTradesQuery(; kw...))
end

end
