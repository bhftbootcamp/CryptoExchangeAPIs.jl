module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

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
    funding_rate(client::AevoClient, query::FundingRateQuery)
    funding_rate(client::AevoClient = Aevo.Futures.public_client; kw...)

Returns the funding rate history for the instrument.

[`GET funding-history`](https://api-docs.aevo.xyz/reference/getfundinghistory)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Aevo

result = Aevo.Futures.funding_rate(; 
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
    ...
  ]
}
```
"""
function funding_rate(client::AevoClient, query::FundingRateQuery)
    return APIsRequest{FundingRateData}("GET", "funding-history", query)(client)
end

function funding_rate(client::AevoClient = Aevo.Futures.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end