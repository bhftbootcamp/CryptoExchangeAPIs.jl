module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: HuobiPublicQuery
    #__ empty
end

struct TickerData <: HuobiData
    amount::Maybe{Float64}
    ask::Maybe{Float64}
    askSize::Maybe{Float64}
    bid::Maybe{Float64}
    bidSize::Maybe{Float64}
    close::Maybe{Float64}
    count::Maybe{Int64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    open::Maybe{Float64}
    symbol::String
    vol::Maybe{Float64}
end

"""
    ticker(client::HuobiClient, query::TickerQuery)
    ticker(client::HuobiClient = Huobi.Spot.public_client; kw...)

This endpoint retrieves the latest tickers for all supported pairs.

[`GET market/tickers`](https://huobiapi.github.io/docs/spot/v1/en/#get-latest-tickers-for-all-pairs)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Huobi

result = Huobi.Spot.ticker()

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "ch":null,
  "ts":"2024-05-16T12:50:57.844",
  "code":null,
  "data":[
    {
      "amount":5.379805390589e8,
      "ask":0.001716,
      "askSize":90895.4464,
      "bid":0.001697,
      "bidSize":53912.9097,
      "close":0.001706,
      "count":12134,
      "high":0.001773,
      "low":0.001683,
      "open":0.001716,
      "symbol":"sylousdt",
      "vol":924950.6866947605
    },
    ...
  ]
}
```
"""
function ticker(client::HuobiClient, query::TickerQuery)
    return APIsRequest{Data{Vector{TickerData}}}("GET", "market/tickers", query)(client)
end

function ticker(client::HuobiClient = Huobi.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
