module FundingHistory

export FundingHistoryQuery,
    FundingHistoryData,
    funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingHistoryQuery <: AevoPublicQuery
    instrument_name::String
    start_time::Maybe{DateTime} = nothing
    end_time::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
end

struct FundingRecord <: AevoData
    instrument_name::String
    timestamp::NanoDate
    funding_rate::Float64
    mark_price::Float64
end 

struct FundingHistoryData <: AevoData
    funding_history::Vector{FundingRecord}
end

"""
    funding_history(client::AevoClient, query::FundingHistoryQuery)
    funding_history(client::AevoClient = Aevo.Futures.public_client; kw...)

Returns the funding rate history for the instrument.

[`GET funding-history`](https://api-docs.aevo.xyz/reference/getfundinghistory)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Aevo

result = Aevo.Futures.funding_history(; 
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
function funding_history(client::AevoClient, query::FundingHistoryQuery)
    return APIsRequest{FundingHistoryData}("GET", "funding-history", query)(client)
end

function funding_history(client::AevoClient = Aevo.public_client; kw...)
    return funding_history(client, FundingHistoryQuery(; kw...))
end

end