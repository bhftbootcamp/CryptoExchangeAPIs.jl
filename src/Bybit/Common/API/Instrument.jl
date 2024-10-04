module Instrument

export InstrumentQuery,
    InstrumentData,
    instrument

export ProductType,
    StatusFilter

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum ProductType begin
    spot
    linear
    inverse
    option
end

@enum StatusFilter begin
    PreLaunch
    Trading
    Delivering
    Closed
end

Base.@kwdef struct InstrumentQuery <: BybitPublicQuery
    category::ProductType
    symbol::Maybe{String} = nothing
    status::Maybe{StatusFilter} = nothing
    baseCoin::Maybe{String} = nothing
    limit::Maybe{Int64} = nothing
    cursor::Maybe{String} = nothing
end

struct LotSizeFliter
    basePrecision::Maybe{Float64}
    quotePrecision::Maybe{Float64}
    minOrderQty::Maybe{Float64}
    maxOrderQty::Maybe{Float64}
    minOrderAmt::Maybe{Float64}
    maxOrderAmt::Maybe{Float64}
end

struct PriceFilter
    tickSize::Maybe{Float64}
end

struct RistParameters
    limitParameter::Maybe{Float64}
    marketParameter::Maybe{Float64}
end

struct InstrumentData <: BybitData
    symbol::String
    baseCoin::String
    quoteCoin::String
    innovation::Maybe{Bool}
    status::StatusFilter
    marginTrading::Maybe{String}
    lotSizeFilter::Maybe{LotSizeFliter}
    priceFilter::Maybe{PriceFilter}
    riskParameters::Maybe{RistParameters}
end

"""
    instrument(client::BybitClient, query::InstrumentQuery)
    instrument(client::BybitClient = Bybit.Common.public_client; kw...)

Query for the instrument specification of online trading pairs.

[`GET /v5/market/instruments-info`](https://bybit-exchange.github.io/docs/v5/market/instrument)

## Parameters:

| Parameter | Type           | Required | Description                                |
|:----------|:---------------|:---------|:-------------------------------------------|
| category  | ProductType    | true     | `spot` `linear` `inverse` `option`         |
| symbol    | String         | false    |                                            |
| status    | StatusFilter   | false    | `PreLaunch` `Trading` `Delivering` `Closed`|
| baseCoin  | String         | false    |                                            |
| limit     | String         | false    |                                            |
| сгкыщк    | String         | false    |                                            |


## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

result = Bybit.Common.instrument(;
    category = Bybit.Common.Instrument.spot
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
        "innovation":false,
        "status":"Trading",
        "marginTrading":"utaOnly",
        "lotSizeFilter":{
          "basePrecision":1.0e-6,
          "quotePrecision":1.0e-8,
          "minOrderQty":4.8e-5,
          "maxOrderQty":71.73956243,
          "minOrderAmt":1.0,
          "maxOrderAmt":4.0e6
        },
        "priceFilter":{
          "tickSize":0.01
        },
        "riskParameters":{
          "limitParameter":0.03,
          "marketParameter":0.03
        }
      },
    ...
  ]
}

```
"""
function instrument(client::BybitClient, query::InstrumentQuery)
    return APIsRequest{Data{List{InstrumentData}}}("GET", "/v5/market/instruments-info", query)(client)
end

function instrument(client::BybitClient = Bybit.Common.public_client; kw...)
    return instrument(client, InstrumentQuery(; kw...))
end

end
