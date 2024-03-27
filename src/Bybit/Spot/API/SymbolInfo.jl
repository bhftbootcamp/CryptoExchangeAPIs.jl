module SymbolInfo

export SymbolInfoQuery,
    SymbolInfoData,
    symbol_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bybit
using CryptoAPIs.Bybit: Data, List, Rows
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct SymbolInfoQuery <: BybitPublicQuery
    #__ empty
end

struct SymbolInfoData <: BybitData
    alias::String
    baseCoin::String
    basePrecision::Float64
    category::Int64
    innovation::Int64
    maxTradeAmt::Float64
    maxTradeQty::Float64
    minPricePrecision::Float64
    minTradeAmt::Float64
    minTradeQty::Float64
    name::String
    quoteCoin::String
    quotePrecision::Float64
    showStatus::Int64
end

"""
    symbol_info(client::BybitClient, query::SymbolInfoQuery)
    symbol_info(client::BybitClient = Bybit.Spot.public_client; kw...)

Get the specification of symbol information.

[`GET /spot/v3/public/symbols`](https://bybit-exchange.github.io/docs/spot/public/instrument#http-request)

## Code samples:

```julia
using Serde
using CryptoAPIs.Bybit

result = Bybit.Spot.symbol_info()

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
          "alias":"BTCUSDT",
          "baseCoin":"BTC",
          "basePrecision":1.0e-6,
          "category":1,
          "innovation":0,
          "maxTradeAmt":2.0e6,
          "maxTradeQty":71.73956243,
          "minPricePrecision":0.01,
          "minTradeAmt":1.0,
          "minTradeQty":4.8e-5,
          "name":"BTCUSDT",
          "quoteCoin":"USDT",
          "quotePrecision":1.0e-8,
          "showStatus":1
        },
      ...
    ],
    "nextPageCursor":null,
    "category":null
  },
  "retExtInfo":{
    
  },
  "time":"2024-03-25T18:58:15.868999936"
}
```
"""
function symbol_info(client::BybitClient, query::SymbolInfoQuery)
    return APIsRequest{Data{List{SymbolInfoData}}}("GET", "/spot/v3/public/symbols", query)(client)
end

function symbol_info(client::BybitClient = Bybit.Spot.public_client; kw...)
    return symbol_info(client, SymbolInfoQuery(; kw...))
end

end
