module SymbolInfo

export SymbolInfoQuery,
    SymbolInfoData,
    symbols_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolInfoQuery <: HuobiPublicQuery
    ts::Maybe{Int64} = nothing
end

struct SymbolInfoData <: HuobiData
    symbol::Maybe{String}
    bcdn::Maybe{String}
    qcdn::Maybe{String}
    bc::Maybe{String}
    qc::Maybe{String}
    state::Maybe{String}
    cd::Maybe{Bool}
    te::Maybe{Bool}
    toa::Maybe{NanoDate}
    sp::Maybe{String}
    w::Maybe{Int64}
    ttp::Maybe{Float64}
    tap::Maybe{Float64}
    tpp::Maybe{Float64}
    fp::Maybe{Float64}
    tags::Maybe{String}
    d::Maybe{Int64}
    elr::Maybe{String}
end

"""
    symbols_info(client::HuobiClient, query::SymbolInfoQuery)
    symbols_info(client::HuobiClient = Huobi.Spot.public_client; kw...)

Get all Supported Trading Symbol.

[`GET v1/settings/common/symbols`](https://www.htx.com/en-in/opend/newApiPages/?id=7ec51cb5-7773-11ed-9966-0242ac110003)

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| ts            | Int64      | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Huobi

result = Huobi.Spot.symbols_info()

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "ch":null,
  "ts":"2024-09-26T13:42:55.368999936",
  "code":null,
  "data":[
    {
      "symbol":"letusdt",
      "bcdn":"LET",
      "qcdn":"USDT",
      "bc":"let",
      "qc":"usdt",
      "state":"offline",
      "cd":false,
      "te":false,
      "toa":"2018-01-01T04:00:00",
      "sp":"st",
      "w":950000000,
      "ttp":8.0,
      "tap":4.0,
      "tpp":6.0,
      "fp":8.0,
      "tags":"",
      "d":null,
      "elr":null
    },
    ...
  ]
}
```
"""
function symbols_info(client::HuobiClient, query::SymbolInfoQuery)
    return APIsRequest{Data{Vector{SymbolInfoData}}}("GET", "v1/settings/common/symbols", query)(client)
end

function symbols_info(client::HuobiClient = Huobi.Spot.public_client; kw...)
    return symbols_info(client, SymbolInfoQuery(; kw...))
end

end
