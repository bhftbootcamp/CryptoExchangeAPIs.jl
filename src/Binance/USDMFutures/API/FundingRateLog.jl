module FundingRateLog

export FundingRateLogQuery,
    FundingRateLogData,
    funding_rate_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateLogQuery <: BinancePublicQuery
    symbol::String
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
end

struct FundingRateLogData <: BinanceData
    symbol::String
    fundingRate::Float64
    fundingTime::NanoDate
    markPrice::Maybe{Float64}
end

function Serde.isempty(::Type{FundingRateLogData}, x)::Bool
    return x === ""
end

"""
    funding_rate_log(client::BinanceClient, query::FundingRateLogQuery)
    funding_rate_log(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

Get funding rate history

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

result = Binance.USDMFutures.funding_rate_log(; symbol = "BTCUSDT")

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
function funding_rate_log(client::BinanceClient, query::FundingRateLogQuery)
    return APIsRequest{Vector{FundingRateLogData}}("GET", "fapi/v1/fundingRate", query)(client)
end

function funding_rate_log(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return funding_rate_log(client, FundingRateLogQuery(; kw...))
end

end
