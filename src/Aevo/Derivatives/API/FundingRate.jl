module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Aevo
using CryptoAPIs: Maybe, APIsRequest

@enum InstrumentType OPTION SPOT PERPETUAL

Base.@kwdef struct FundingRateQuery <: AevoPublicQuery
    instrument_name::String
    start_time::Maybe{DateTime} = nothing
    end_time::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

struct FundingHistory <: AevoData
    instrument_name::String
    timestamp::NanoDate
    funding_rate::Float64
    mark_price::Float64
end 

struct FundingRateData <: AevoData
    funding_history::Vector{FundingHistory}
end

"""
    product_stats(client::AevoClient, query::FundingRateQuery)
    product_stats(client::AevoClient = Aevo.Derivatives.public_client; kw...)

Returns the funding rate history for the instrument.

[`GET funding-history`](https://api-docs.aevo.xyz/reference/getfundinghistory)

## Code samples:

```julia
using Serde
using CryptoAPIs.Aevo

result = Aevo.Derivatives.funding_rate(; 
    instrument_name = "ETH-PERP",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "funding_history":[
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T22:00:00",
      "funding_rate":2.0e-6,
      "mark_price":3026.093939
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T21:00:00",
      "funding_rate":4.0e-6,
      "mark_price":2997.539571
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T20:00:00",
      "funding_rate":3.6e-5,
      "mark_price":3003.802278
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T19:00:00",
      "funding_rate":4.8e-5,
      "mark_price":2992.001439
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T18:00:00",
      "funding_rate":3.0e-5,
      "mark_price":2985.064606
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T17:00:00",
      "funding_rate":-1.1e-5,
      "mark_price":2971.5032
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T16:00:00",
      "funding_rate":1.6e-5,
      "mark_price":2969.04889
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T15:00:00",
      "funding_rate":1.3e-5,
      "mark_price":2981.672008
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T14:00:00",
      "funding_rate":1.0e-5,
      "mark_price":3037.555603
    },
    {
      "instrument_name":"ETH-PERP",
      "timestamp":"2024-07-08T13:00:00",
      "funding_rate":2.0e-6,
      "mark_price":3049.066838
    }
  ]
}
```
"""
function funding_rate(client::AevoClient, query::FundingRateQuery)
    return APIsRequest{FundingRateData}("GET", "funding-history", query)(client)
end

function funding_rate(client::AevoClient = Aevo.Derivatives.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end