module Instruments

export InstrumentsQuery,
    InstrumentsData,
    instruments

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okex
using CryptoExchangeAPIs.Okex: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstType begin
    SPOT
    MARGIN
    SWAP
    FUTURES
    OPTION
end

Base.@kwdef struct InstrumentsQuery <: OkexPublicQuery
    instType::Maybe{InstType.T}
    uly::Maybe{String} = nothing
    instFamily::Maybe{String} = nothing
    instId::Maybe{String} = nothing
end

struct InstrumentsData <: OkexData
    instId::String
    baseCcy::String
    quoteCcy::String
    ctMult::Maybe{String}
    ctType::Maybe{String}
    ctVal::Maybe{Float64}
    ctValCcy::Maybe{String}
    expTime::Maybe{NanoDate}
    instFamily::Maybe{String}
    instType::String
    lever::Maybe{Float64}
    listTime::Maybe{NanoDate}
    lotSz::Maybe{Float64}
    maxIcebergSz::Maybe{Float64}
    maxLmtAmt::Maybe{Float64}
    maxLmtSz::Maybe{Int64}
    maxMktAmt::Maybe{Float64}
    maxMktSz::Maybe{Int64}
    maxStopSz::Maybe{Int64}
    maxTriggerSz::Maybe{Float64}
    maxTwapSz::Maybe{Float64}
    minSz::Maybe{Float64}
    optType::Maybe{String}
    settleCcy::Maybe{String}
    state::Maybe{String}
    ruleType::Maybe{String}
    stk::Maybe{Float64}
    tickSz::Maybe{Float64}
    uly::Maybe{String}
end

function Serde.isempty(::Type{InstrumentsData}, x)
    return x === ""
end

"""
    instruments(client::OkexClient, query::InstrumentsQuery)
    instruments(client::OkexClient = Okex.Common.public_client; kw...)

Retrieve a list of instruments with open contracts.

[`GET api/v5/public/instruments`](https://www.okx.com/docs-v5/en/#public-data-rest-api-get-instruments)

## Parameters:

| Parameter       | Type     | Required    | Description         |
|:----------------|:---------|:------------|:--------------------|
| instType        | InstType | true        | Instrument type:    |
|                 |          |             | SPOT, MARGIN, SWAP, |
|                 |          |             | FUTURES, OPTION     | 
| uly             | String   | Conditional |                     |
| instFamily      | String   | Conditional |                     |
| instId          | String   | false       |                     |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Okex

result = Okex.Common.instruments(;
    instType = Okex.Common.Instruments.SPOT,
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
      "instId":"BTC-AUD",
      "baseCcy":"BTC",
      "quoteCcy":"AUD",
      "ctMult":null,
      "ctType":null,
      "ctVal":null,
      "ctValCcy":null,
      "expTime":null,
      "instFamily":null,
      "instType":"SPOT",
      "lever":null,
      "listTime":"2024-08-16T01:21:44",
      "lotSz":1.0e-7,
      "maxIcebergSz":9.9999999999e10,
      "maxLmtAmt":2.0e7,
      "maxLmtSz":99999999999,
      "maxMktAmt":1.0e6,
      "maxMktSz":1000000,
      "maxStopSz":1000000,
      "maxTriggerSz":9.9999999999e10,
      "maxTwapSz":9.9999999999e10,
      "minSz":0.0001,
      "optType":null,
      "settleCcy":null,
      "state":"live",
      "ruleType":"normal",
      "stk":null,
      "tickSz":0.1,
      "uly":null
    },
    ...
}
```
"""
function instruments(client::OkexClient, query::InstrumentsQuery)
    return APIsRequest{Data{InstrumentsData}}("GET", "api/v5/public/instruments", query)(client)
end

function instruments(client::OkexClient = Okex.public_client; kw...)
    return instruments(client, InstrumentsQuery(; kw...))
end

end