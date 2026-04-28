module Instruments

export InstrumentsQuery,
    InstrumentsData,
    instruments

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstType begin
    SPOT
    MARGIN
    SWAP
    FUTURES
    OPTION
end

@enumx State begin
    live
    suspend
    rebase
    preopen
    test
    settling
end

Base.@kwdef struct InstrumentsQuery <: OkxPublicQuery
    instType::InstType.T
    uly::Maybe{String} = nothing
    instFamily::Maybe{String} = nothing
    instId::Maybe{String} = nothing
end

struct InstrumentsData <: OkxData
    instId::String
    baseCcy::Maybe{String}
    quoteCcy::Maybe{String}
    ctMult::Maybe{String}
    ctType::Maybe{String}
    ctVal::Maybe{Float64}
    ctValCcy::Maybe{String}
    expTime::Maybe{NanoDate}
    instFamily::Maybe{String}
    instType::InstType.T
    lever::Maybe{Float64}
    listTime::NanoDate
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
    state::State.T
    ruleType::Maybe{String}
    stk::Maybe{Float64}
    tickSz::Maybe{Float64}
    uly::Maybe{String}
end

function Serde.isempty(::Type{InstrumentsData}, x)
    return x === ""
end

"""
    instruments(client::OkxClient, query::InstrumentsQuery)
    instruments(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

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
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Public.instruments(;
    instType = Okx.API.V5.Public.Instruments.InstType.SPOT,
)
```
"""
function instruments(client::OkxClient, query::InstrumentsQuery)
    return APIsRequest{Data{InstrumentsData}}("GET", "api/v5/public/instruments", query)(client)
end

function instruments(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return instruments(client, InstrumentsQuery(; kw...))
end

end