module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct TickersQuery <: BybitPublicQuery
    category::Category.T
    symbol::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    expDate::Maybe{String} = nothing
end

function Serde.ser_type(::Type{<:TickersQuery}, x::Category.T)::String
    x == Category.OPTION  && return "option"
    x == Category.SPOT    && return "spot"
    x == Category.LINEAR  && return "linear"
    x == Category.INVERSE && return "inverse"
end

struct TickersData <: BybitData
    symbol::String
    bid1Price::Maybe{Float64}
    bid1Size::Maybe{Float64}
    ask1Price::Maybe{Float64}
    ask1Size::Maybe{Float64}
    lastPrice::Float64
    prevPrice24h::Maybe{Float64}
    price24hPcnt::Maybe{Float64}
    highPrice24h::Float64
    lowPrice24h::Float64
    turnover24h::Float64
    volume24h::Float64
    usdIndexPrice::Maybe{Float64}
end

function Serde.isempty(::Type{<:TickersData}, x::String)::Bool
    return x === ""
end

"""
    tickers(client::BybitClient, query::TickersQuery)
    tickers(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

[`GET /v5/market/tickers`](https://bybit-exchange.github.io/docs/v5/market/tickers)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:---------------------------|
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | false    |                            |
| baseCoin  | String   | false    |                            |
| expDate   | String   | false    |                            |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.tickers(;
    category = Bybit.V5.Market.Tickers.Category.SPOT,
    symbol = "BTCUSDT",
)
```
"""
function tickers(client::BybitClient, query::TickersQuery)
    return APIsRequest{Data{List{TickersData}}}("GET", "v5/market/tickers", query)(client)
end

function tickers(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return tickers(client, TickersQuery(; kw...))
end

end

