module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bybit
using CryptoAPIs.Bybit: Data, List, Rows
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: BybitPublicQuery
    symbol::Maybe{String} = nothing
end

struct TickerData <: BybitData
    ap::Float64
    bp::Float64
    h::Float64
    l::Float64
    lp::Float64
    o::Float64
    qv::Float64
    s::String
    t::NanoDate
    v::Float64
end

"""
    ticker(client::BybitClient, query::TickerQuery)
    ticker(client::BybitClient = Bybit.Spot.public_client; kw...)

[`GET /spot/v3/public/quote/ticker/24hr`](https://bybit-exchange.github.io/docs/spot/public/tickers#http-request)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bybit

result = Bybit.Spot.ticker(;
    symbol = "ADAUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"OK",
  "result":{
    "ap":0.6636,
    "bp":0.6634,
    "h":0.6687,
    "l":0.6315,
    "lp":0.6633,
    "o":0.6337,
    "qv":1.1594252877069e7,
    "s":"ADAUSDT",
    "t":"2024-03-25T19:05:35.491000064",
    "v":1.780835204e7
  },
  "retExtInfo":{},
  "time":"2024-03-25T19:05:38.912999936"
}
```
"""
function ticker(client::BybitClient, query::TickerQuery)
    return if isnothing(query.symbol)
        APIsRequest{Data{List{TickerData}}}("GET", "spot/v3/public/quote/ticker/24hr", query)(client)
    else
        APIsRequest{Data{TickerData}}("GET", "spot/v3/public/quote/ticker/24hr", query)(client)
    end
end

function ticker(client::BybitClient = Bybit.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
