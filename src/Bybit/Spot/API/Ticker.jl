module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct TickerQuery <: BybitPublicQuery
    category::Category
    symbol::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    expDate::Maybe{String} = nothing
end

function Serde.ser_type(::Type{<:TickerQuery}, x::Category)::String
    x == OPTION  && return "option"
    x == SPOT    && return "spot"
    x == LINEAR  && return "linear"
    x == INVERSE && return "inverse"
  end

struct TickerData <: BybitData
    symbol::String
    bid1Price::Maybe{Float64}
    bid1Size::Maybe{Float64}
    ask1Price::Maybe{Float64}
    ask1Size::Maybe{Float64}
    lastPrice::Float64
    prevPrice24h::Float64
    price24hPcnt::Maybe{Float64}
    highPrice24h::Float64
    lowPrice24h::Float64
    turnover24h::Float64
    volume24h::Float64
    usdIndexPrice::Maybe{Float64}
end

"""
    ticker(client::BybitClient, query::TickerQuery)
    ticker(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /v5/market/tickers`](https://bybit-exchange.github.io/docs/v5/market/tickers)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:-------------------------- |
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | false    |                            |
| baseCoin  | String   | false    |                            |
| expDate   | String   | false    |                            |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Spot.ticker(;
    category = Bybit.Spot.Ticker.SPOT,
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "list":[
      {
        "symbol":"BTCUSDT",
        "bid1Price":90977.73,
        "bid1Size":0.033508,
        "ask1Price":90977.74,
        "ask1Size":0.124391,
        "lastPrice":90976.95,
        "prevPrice24h":94379.41,
        "price24hPcnt":null,
        "highPrice24h":95950.05,
        "lowPrice24h":90547.11,
        "turnover24h":2.838946290225581e9,
        "volume24h":30219.056193,
        "usdIndexPrice":90893.782055
      }
    ],
    "nextPageCursor":null,
    "category":"spot"
  },
  "retExtInfo":{},
  "time":"2025-01-13T12:14:58.473999872"
}
```
"""
function ticker(client::BybitClient, query::TickerQuery)
    return APIsRequest{Data{List{TickerData}}}("GET", "/v5/market/tickers", query)(client)
end

function ticker(client::BybitClient = Bybit.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
