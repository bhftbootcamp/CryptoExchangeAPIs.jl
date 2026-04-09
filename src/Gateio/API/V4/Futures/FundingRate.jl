module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt

Base.@kwdef struct FundingRateQuery <: GateioPublicQuery
    contract::String
    settle::Settle.T
    limit::Maybe{Int64} = nothing
    from::Maybe{DateTime} = nothing
    to::Maybe{DateTime} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{FundingRateQuery}, ::Val{:settle}) = true

struct FundingRateData <: GateioData
    t::NanoDate
    r::Maybe{Float64}
end

"""
    funding_rate(client::GateioClient, query::FundingRateQuery)
    funding_rate(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Funding rate history.

[`GET api/v4/futures/{settle}/funding_rate`](https://www.gate.io/docs/developers/apiv4/en/#funding-rate-history)

## Parameters:

| Parameter | Type     | Required | Description                                                                 |
|:----------|:---------|:---------|:----------------------------------------------------------------------------|
| settle    | Settle   | true     | btc usdt                                                                    |
| contract  | String   | true     | Futures contract (e.g. BTC\\_USDT).                                         |
| limit     | Int64    | false    | Maximum number of records returned.                                         |
| from      | DateTime | false    | Start timestamp. Defaults to the start of the range implied by `to`+`limit`.|
| to        | DateTime | false    | End timestamp. Defaults to current time.                                    |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.funding_rate(; 
    settle = Gateio.API.V4.Futures.FundingRate.Settle.usdt,
    contract = "BTC_USDT",
)
```
"""
function funding_rate(client::GateioClient, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "api/v4/futures/$(query.settle)/funding_rate", query)(client)
end

function funding_rate(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
