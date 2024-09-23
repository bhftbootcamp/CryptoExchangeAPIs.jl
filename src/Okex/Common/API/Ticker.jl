module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Okex
using CryptoExchangeAPIs.Okex: Data, InstType
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickersQuery <: OkexPublicQuery
    instFamily::Maybe{String} = nothing
    instType::Maybe{InstType} = nothing
    uly::Maybe{String} = nothing
end

struct TickerData <: OkexData
    askPx::Maybe{Float64}
    askSz::Maybe{Float64}
    bidPx::Maybe{Float64}
    bidSz::Maybe{Float64}
    high24h::Maybe{Float64}
    instId::Maybe{String}
    instType::Maybe{InstType}
    last::Maybe{Float64}
    lastSz::Maybe{Float64}
    low24h::Maybe{Float64}
    open24h::Maybe{Float64}
    sodUtc0::Maybe{Float64}
    sodUtc8::Maybe{Float64}
    ts::Maybe{NanoDate}
    vol24h::Maybe{Float64}
    volCcy24h::Maybe{Float64}
end

function Serde.isempty(::Type{TickerData}, x)
    return x === ""
end

"""
    ticker(client::OkexClient, query::TickerQuery)
    ticker(client::OkexClient = Okex.Common.public_client; kw...)

Retrieve the latest price snapshot, best bid/ask price, and trading volume in the last 24 
hours.

[`GET api/v5/market/tickers`](https://www.okx.com/docs-v5/en/#rest-api-market-data-get-tickers)

## Parameters:

| Parameter       | Type     | Required | Description     |
|:----------------|:---------|:---------|:----------------|
| instFamily      | String   | false    | Instrument type:|
|                 |          |          | SPOT, SWAP,     |
|                 |          |          | FUTURES, OPTION | 
| instrument_name | InstType | true     |                 |
| uly             | String   | false    |                 |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Okex

result = Okex.Common.ticker(;
     instType = Okex.SPOT,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "msg":"",
  "code":0,
  "data":[
    {
      "askPx":0.04625,
      "askSz":130.0,
      "bidPx":0.04615,
      "bidSz":130.0,
      "high24h":0.04779,
      "instId":"MDT-USDT",
      "instType":"SPOT",
      "last":0.04621,
      "lastSz":189.496477,
      "low24h":0.04483,
      "open24h":0.04557,
      "sodUtc0":0.04593,
      "sodUtc8":0.04688,
      "ts":"2024-09-23T13:53:17.512999936",
      "vol24h":1.626763924978e6,
      "volCcy24h":75454.11949093638
    },
    ...
}
```
"""
function ticker(client::OkexClient, query::TickersQuery)
    return APIsRequest{Data{TickerData}}("GET", "api/v5/market/tickers", query)(client)
end

function ticker(client::OkexClient = Okex.Common.public_client; kw...)
    return ticker(client, TickersQuery(; kw...))
end

end