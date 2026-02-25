module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

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

Serde.isempty(::Type{FundingRateData}, x::AbstractString) = isempty(x)

"""
    funding_rate(client::BinanceClient, query::FundingRateQuery)
    funding_rate(client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config); kw...)

Get funding rate history of perpetual futures.

[`GET dapi/v1/fundingRate`](https://binance-docs.github.io/apidocs/delivery/en/#get-funding-rate-history-of-perpetual-futures)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | true     |             |
| endTime   | DateTime | false    |             |
| limit     | Int64    | false    |             |
| startTime | DateTime | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.DAPI.V1.funding_rate(;
    symbol = "BTCUSD_PERP",
)
```
"""
function funding_rate(client::BinanceClient, query::FundingRateQuery)
    return APIsRequest{Vector{FundingRateData}}("GET", "dapi/v1/fundingRate", query)(client)
end

function funding_rate(
    client::BinanceClient = Binance.BinanceClient(Binance.public_dapi_config);
    kw...,
)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end

