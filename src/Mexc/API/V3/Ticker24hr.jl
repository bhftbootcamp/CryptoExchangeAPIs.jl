module Ticker24hr

export Ticker24hrQuery,
    Ticker24hrData,
    ticker24hr

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct Ticker24hrQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
end

struct Ticker24hrData <: MexcData
    symbol::String
    priceChange::Float64
    priceChangePercent::Float64
    prevClosePrice::Float64
    lastPrice::Float64
    bidPrice::Float64
    bidQty::Maybe{Float64}
    askPrice::Float64
    askQty::Maybe{Float64}
    openPrice::Float64
    highPrice::Float64
    lowPrice::Float64
    volume::Float64
    quoteVolume::Maybe{Float64}
    openTime::NanoDate
    closeTime::NanoDate
    count::Maybe{Int64}
end

"""
    ticker24hr(client::MexcSpotClient, query::Ticker24hrQuery)
    ticker24hr(client::MexcSpotClient = Mexc.MexcSpotClient(Mexc.public_spot_config); kw...)

24hr Ticker Price Change Statistics.

[`GET api/v3/ticker/24hr`](https://www.mexc.com/api-docs/spot-v3/market-data-endpoints#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.ticker24hr(; symbol = "ADAUSDT")
```
"""
function ticker24hr(client::MexcSpotClient, query::Ticker24hrQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{Ticker24hrData}}("GET", "api/v3/ticker/24hr", query)(client)
    else
        APIsRequest{Ticker24hrData}("GET", "api/v3/ticker/24hr", query)(client)
    end
end

function ticker24hr(
    client::MexcSpotClient = MexcSpotClient(Mexc.public_spot_config);
    kw...,
)
    return ticker24hr(client, Ticker24hrQuery(; kw...))
end

end
