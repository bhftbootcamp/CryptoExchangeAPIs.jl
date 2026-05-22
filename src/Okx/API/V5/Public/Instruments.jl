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
    alias::Maybe{String}
    auctionEndTime::Maybe{String}
    baseCcy::Maybe{String}
    category::Maybe{String}
    contTdSwTime::Maybe{String}
    ctMult::Maybe{String}
    ctType::Maybe{String}
    ctVal::Maybe{Float64}
    ctValCcy::Maybe{String}
    expTime::Maybe{NanoDate}
    freq::Maybe{String}
    futureSettlement::Maybe{Bool}
    groupId::Maybe{String}
    instCategory::Maybe{String}
    instFamily::Maybe{String}
    instId::String
    instIdCode::Maybe{Int64}
    instType::InstType.T
    lever::Maybe{Float64}
    listTime::NanoDate
    longPosRemainingQuota::Maybe{String}
    lotSz::Maybe{Float64}
    maxIcebergSz::Maybe{Float64}
    maxLmtAmt::Maybe{Float64}
    maxLmtSz::Maybe{Float64}
    maxMktAmt::Maybe{Float64}
    maxMktSz::Maybe{Float64}
    maxPlatOICoinLmt::Maybe{String}
    maxPlatOILmt::Maybe{String}
    maxStopSz::Maybe{Float64}
    maxTriggerSz::Maybe{Float64}
    maxTwapSz::Maybe{Float64}
    method::Maybe{String}
    minSz::Maybe{Float64}
    openType::Maybe{String}
    optType::Maybe{String}
    posLmtAmt::Maybe{String}
    posLmtPct::Maybe{String}
    preMktSwTime::Maybe{String}
    quoteCcy::Maybe{String}
    ruleType::Maybe{String}
    seriesId::Maybe{String}
    settleCcy::Maybe{String}
    shortPosRemainingQuota::Maybe{String}
    state::State.T
    stk::Maybe{Float64}
    tickSz::Maybe{Float64}
    tradeQuoteCcyList::Maybe{Vector{Any}}
    uly::Maybe{String}
    upcChg::Maybe{Vector{Any}}
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