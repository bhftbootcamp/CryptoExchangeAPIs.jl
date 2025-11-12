module PredictedFundings

export PredictedFundingsQuery,
    PredictedFundingsData,
    predicted_fundings

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct PredictedFundingsQuery <: HyperliquidPublicQuery
    type::String = "predictedFundings"
end

struct VenueFunding <: HyperliquidData
    fundingRate::String
    nextFundingTime::NanoDate
end

const PredictedFundingsData = Vector{Tuple{String,Vector{Tuple{String,VenueFunding}}}}

"""
    predicted_fundings(client::HyperliquidClient, query::PredictedFundingsQuery)
    predicted_fundings(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Retrieve predicted funding rates for different venues.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#retrieve-predicted-funding-rates-for-different-venues)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.predicted_fundings()
```
"""
function predicted_fundings(client::HyperliquidClient, query::PredictedFundingsQuery)
    return APIsRequest{PredictedFundingsData}("POST", "info", query)(client)
end

function predicted_fundings(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return predicted_fundings(client, PredictedFundingsQuery(; kw...))
end

end

