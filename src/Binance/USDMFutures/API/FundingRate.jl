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
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

struct FundingRateData <: BinanceData
    symbol::String
    fundingRate::Float64
    fundingTime::NanoDate
    markPrice::Maybe{Float64}
end

function Serde.isempty(::Type{<:FundingRateData}, x)::Bool
    return x === ""
end

"""
    funding_rate(client::BinanceClient, query::FundingRateQuery)
    funding_rate(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

Get funding rate history.

[`GET fapi/v1/fundingRate`](https://binance-docs.github.io/apidocs/futures/en/#get-funding-rate-history)

## Parameters:

| Parameter  | Type            | Required | Description |
|:-----------|:----------------|:---------|:------------|
| symbol     | String          | true     |             |
| endTime    | DateTime        | false    |             |
| limit      | Int64           | false    |             |
| startTime  | DateTime        | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.funding_rate(;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "fundingRate":0.00011242,
    "fundingTime":"2024-02-21T08:00:00",
    "markPrice":51595.13521986
  },
  ...
]
```
"""
function funding_rate(client::BinanceClient, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "fapi/v1/fundingRate", query)(client)
end

function funding_rate(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
