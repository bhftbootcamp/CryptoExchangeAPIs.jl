module PremiumIndex

export PremiumIndexQuery,
    PremiumIndexData,
    premium_index

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct PremiumIndexQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
end

struct PremiumIndexData <: BinanceData
    symbol::String
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    estimatedSettlePrice::Maybe{Float64}
    lastFundingRate::Maybe{Float64}
    interestRate::Maybe{Float64}
    nextFundingTime::NanoDate
    time::NanoDate
end

"""
    premium_index(client::BinanceClient, query::PremiumIndexQuery)
    premium_index(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET fapi/v1/premiumIndex`](https://binance-docs.github.io/apidocs/futures/en/#mark-price)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.premium_index(;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "symbol":"BTCUSDT",
  "markPrice":70901.2,
  "indexPrice":70794.23404255,
  "estimatedSettlePrice":70699.56121556,
  "lastFundingRate":0.000442,
  "interestRate":0.0001,
  "nextFundingTime":"2024-04-01T00:00:00",
  "time":"2024-03-31T19:00:35"
}
```
"""
function premium_index(client::BinanceClient, query::PremiumIndexQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{PremiumIndexData}}("GET", "fapi/v1/premiumIndex", query)(client)
    else
        APIsRequest{PremiumIndexData}("GET", "fapi/v1/premiumIndex", query)(client)
    end
end

function premium_index(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return premium_index(client, PremiumIndexQuery(; kw...))
end

end