module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt usd

Base.@kwdef struct FundingRateQuery <: GateioPublicQuery
    contract::String
    settle::Settle.T
    limit::Maybe{Int64} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{FundingRateQuery}, ::Val{:settle}) = true

struct FundingRateData <: GateioData
    t::NanoDate
    r::Maybe{Float64}
end

"""
    funding_rate(client::GateioClient, query::FundingRateQuery)
    funding_rate(client::GateioClient = Gateio.public_client; kw...)

Funding rate history.

[`GET api/v4/futures/{settle}/funding_rate`](https://www.gate.io/docs/developers/apiv4/en/#funding-rate-history)

## Parameters:

| Parameter | Type     | Required | Description  |
|:----------|:---------|:---------|:-------------|
| settle    | Settle   | true     | btc usdt usd |
| contract  | String   | true     |              |
| limit     | Int64    | false    |              |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.funding_rate(; 
    settle = Gateio.API.V4.Futures.FundingRate.Settle.usdt,
    contract = "BTC_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "t":"2024-04-16T08:00:00",
    "r":0.0001
  },
  ...
]
```
"""
function funding_rate(client::GateioClient, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "api/v4/futures/$(query.settle)/funding_rate", query)(client)
end

function funding_rate(client::GateioClient = Gateio.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
