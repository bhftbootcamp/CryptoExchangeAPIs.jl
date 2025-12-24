module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
end

struct RiseFallRates <: MexcData
    zone::String
    r::Maybe{Float64}
    v::Maybe{Float64}
    r7::Maybe{Float64}
    r30::Maybe{Float64}
    r90::Maybe{Float64}
    r180::Maybe{Float64}
    r365::Maybe{Float64}
end

struct TickerData <: MexcData
    contractId::Int64
    symbol::String
    lastPrice::Float64
    bid1::Maybe{Float64}
    ask1::Maybe{Float64}
    volume24::Float64
    amount24::Float64
    holdVol::Float64
    lower24Price::Float64
    high24Price::Float64
    riseFallRate::Float64
    riseFallValue::Float64
    indexPrice::Float64
    fairPrice::Float64
    fundingRate::Float64
    maxBidPrice::Float64
    minAskPrice::Float64
    timestamp::NanoDate
    riseFallRates::RiseFallRates
    riseFallRatesOfTimezone::Vector{Float64}
end

"""
    ticker(client::MexcFuturesClient, query::TickerQuery)
    ticker(client::MexcFuturesClient = MexcFuturesClient(Mexc.public_futures_config); kw...)

Get Ticker (Contract Market Data).

[`GET api/v1/contract/ticker`](https://www.mexc.com/api-docs/futures/market-endpoints#get-ticker-contract-market-data)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V1.Contract.ticker(; symbol = "ADA_USDT")
```
"""
function ticker(client::MexcFuturesClient, query::TickerQuery)
    datatype = isnothing(query.symbol) ? Vector{TickerData} : TickerData
    APIsRequest{Mexc.FuturesData{datatype}}("GET", "api/v1/contract/ticker", query)(client)
end

function ticker(
    client::MexcFuturesClient = MexcFuturesClient(Mexc.public_futures_config);
    kw...,
)
    return ticker(client, TickerQuery(; kw...))
end

end
