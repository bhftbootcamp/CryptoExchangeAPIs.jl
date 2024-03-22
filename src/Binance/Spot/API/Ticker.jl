module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
    symbols::Maybe{Vector{String}} = nothing
    type::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{<:TickerQuery}, x::Vector{String})::String
    return "[\"" * join(x, "\",\"") * "\"]"
end

struct TickerData <: BinanceData
    symbol::String
    askPrice::Maybe{Float64}
    askQty::Maybe{Float64}
    bidPrice::Maybe{Float64}
    bidQty::Maybe{Float64}
    closeTime::Maybe{NanoDate}
    count::Maybe{Int64}
    firstId::Maybe{Int64}
    highPrice::Maybe{Float64}
    lastId::Maybe{Int64}
    lastPrice::Maybe{Float64}
    lastQty::Maybe{Float64}
    lowPrice::Maybe{Float64}
    openPrice::Maybe{Float64}
    openTime::Maybe{NanoDate}
    prevClosePrice::Maybe{Float64}
    priceChange::Maybe{Float64}
    priceChangePercent::Maybe{Float64}
    quoteVolume::Maybe{Float64}
    volume::Maybe{Float64}
    weightedAvgPrice::Maybe{Float64}
end

"""
    ticker(client::BinanceClient, query::TickerQuery)
    ticker(client::BinanceClient = Binance.Spot.public_client; kw...)

24 hour rolling window price change statistics.

[`GET api/v3/ticker/24hr`](https://binance-docs.github.io/apidocs/spot/en/#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type           | Required | Description |
|:----------|:---------------|:---------|:------------|
| symbol    | String         | false    |             |
| symbols   | Vector{String} | false    |             |
| type      | String         | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.Spot.ticker(;
    symbol = "ADAUSDT",
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "symbol":"ADAUSDT",
  "askPrice":0.631,
  "askQty":53.4,
  "bidPrice":0.6309,
  "bidQty":23714.9,
  "closeTime":"2024-03-21T14:04:37.151000064",
  "count":265067,
  "firstId":482014355,
  "highPrice":0.6459,
  "lastId":482279421,
  "lastPrice":0.631,
  "lastQty":1282.0,
  "lowPrice":0.5757,
  "openPrice":0.6048,
  "openTime":"2024-03-20T14:04:37.151000064",
  "prevClosePrice":0.6048,
  "priceChange":0.0262,
  "priceChangePercent":4.332,
  "quoteVolume":1.363472992331e8,
  "volume":2.185537682e8,
  "weightedAvgPrice":0.62386158
}
```
"""
function ticker(client::BinanceClient, query::TickerQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{TickerData}}("GET", "api/v3/ticker/24hr", query)(client)
    else
        APIsRequest{TickerData}("GET", "api/v3/ticker/24hr", query)(client)
    end
end

function ticker(client::BinanceClient = Binance.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
