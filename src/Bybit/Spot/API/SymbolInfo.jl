module SymbolInfo

export SymbolInfoQuery,
    SymbolInfoData,
    symbol_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Category OPTION SPOT LINEAR INVERSE

Base.@kwdef struct SymbolInfoQuery <: BybitPublicQuery
    category::Category
    symbol::Maybe{String} = nothing
    status::Maybe{String} = nothing
    baseCoin::Maybe{String} = nothing
    limit::Maybe{Int64} = nothing
    cursor::Maybe{String} = nothing
end

function Serde.ser_type(::Type{<:SymbolInfoQuery}, x::Category)::String
  x == OPTION  && return "option"
  x == SPOT    && return "spot"
  x == LINEAR  && return "linear"
  x == INVERSE && return "inverse"
end

struct LotSizeFilter <: BybitData
  basePrecision::Float64
  quotePrecision::Float64
  minOrderQty::Float64
  maxOrderQty::Float64
  minOrderAmt::Float64
  maxOrderAmt::Float64
end

struct PriceFilter <: BybitData
  tickSize::Float64
end

struct RiskParameters <: BybitData
  limitParameter::Float64
  marketParameter::Float64
end

struct SymbolInfoData <: BybitData
  symbol::String
  baseCoin::String
  quoteCoin::String
  innovation::Int64
  status::String
  lotSizeFilter::LotSizeFilter
  priceFilter::PriceFilter
  riskParameters::RiskParameters
end

"""
    symbol_info(client::BybitClient, query::SymbolInfoQuery)
    symbol_info(client::BybitClient = Bybit.Spot.public_client; kw...)

Query for the instrument specification of online trading pairs.

[`GET /v5/market/instruments-info`](https://bybit-exchange.github.io/docs/v5/market/instrument)

## Parameters:

| Parameter | Type     | Required | Description                |
|:----------|:---------|:---------|:-------------------------- |
| category  | Category | true     | SPOT LINEAR INVERSE OPTION |
| symbol    | String   | true     |                            |
| status    | String   | true     |                            |
| baseCoin  | String   | true     |                            |
| limit     | Int64    | false    |                            |
| cursor    | String   | true     |                            |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Spot.symbol_info(;
    category = Bybit.Spot.SymbolInfo.SPOT,
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
        "baseCoin":"BTC",
        "quoteCoin":"USDT",
        "innovation":0,
        "status":"Trading",
        "lotSizeFilter":{
          "basePrecision":1.0e-6,
          "quotePrecision":1.0e-8,
          "minOrderQty":4.8e-5,
          "maxOrderQty":83.0,
          "minOrderAmt":1.0,
          "maxOrderAmt":8.0e6
        },
        "priceFilter":{
          "tickSize":0.01
        },
        "riskParameters":{
          "limitParameter":0.02,
          "marketParameter":0.02
        }
      }
    ],
    "nextPageCursor":null,
    "category":"spot"
  },
  "retExtInfo":{},
  "time":"2025-01-13T12:00:59.132"
}
```
"""
function symbol_info(client::BybitClient, query::SymbolInfoQuery)
    return APIsRequest{Data{List{SymbolInfoData}}}("GET", "/v5/market/instruments-info", query)(client)
end

function symbol_info(client::BybitClient = Bybit.Spot.public_client; kw...)
    return symbol_info(client, SymbolInfoQuery(; kw...))
end

end
