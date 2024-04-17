module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
    endTime::Maybe{DateTime} = nothing
    startTime::Maybe{DateTime} = nothing
end

struct FundingRateData <: BinanceData
    symbol::String
    fundingTime::NanoDate
    fundingRate::Maybe{Float64}
    markPrice::Maybe{Float64}
end

"""
    funding_rate(client::BinanceClient, query::FundingRateQuery)
    funding_rate(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)

[`GET /dapi/v1/fundingRate`](https://binance-docs.github.io/apidocs/delivery/en/#get-funding-rate-history-of-perpetual-futures)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| endTime   | DateTime | false    |             |
| limit     | Int64    | false    |             |
| startTime | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.CoinMFutures.funding_rate(;
    symbol = "BTCUSD_PERP",
)

to_pretty_json(result.result)
```

## Result:

```json
[
 {
    "symbol":"BTCUSD_PERP",
    "fundingTime":"2024-02-22T16:00:00",
    "fundingRate":0.00034808,
    "markPrice":51610.0
  },
  ...
]
```
"""
function funding_rate(client::BinanceClient, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "/dapi/v1/fundingRate", query)(client)
end

function funding_rate(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
