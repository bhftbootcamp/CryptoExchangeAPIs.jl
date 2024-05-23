module FundingRate

export FundingRateQuery,
    FundingRateData,
    funding_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Deribit
using CryptoAPIs.Deribit: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateQuery <: DeribitPublicQuery
    end_timestamp::DateTime
    instrument_name::String
    start_timestamp::DateTime
end

struct FundingRateData <: DeribitData
    index_price::Float64
    interest_1h::Float64
    interest_8h::Float64
    prev_index_price::Maybe{Float64}
    timestamp::NanoDate
end

"""
    funding_rate(client::DeribitClient, query::FundingRateQuery)
    funding_rate(client::DeribitClient = Deribit.Common.public_client; kw...)

Retrieves hourly historical interest rate for requested PERPETUAL instrument.

[`GET api/v2/public/get_funding_rate_history`](https://docs.deribit.com/#public-get_funding_rate_history)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| end_timestamp   | DateTime | true     |             |
| instrument_name | String   | true     |             |
| start_timestamp | DateTime | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Deribit

result = Deribit.Common.funding_rate(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = Dates.DateTime("2022-11-08"),
    end_timestamp = Dates.DateTime("2022-11-08") + Day(2),
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":null,
  "jsonrpc":"2.0",
  "testnet":false,
  "usDiff":43615,
  "usOut":"2024-05-17T12:01:49.482341888",
  "usIn":"2024-05-17T12:01:49.438726912",
  "result":[
    {
      "index_price":20516.0,
      "interest_1h":9.873575714940002e-7,
      "interest_8h":4.479902336495525e-5,
      "prev_index_price":20592.45,
      "timestamp":"2022-11-08T01:00:00"
    },
    ...
  ]
}
```
"""
function funding_rate(client::DeribitClient, query::FundingRateQuery)
    return APIsRequest{Data{Vector{FundingRateData}}}("GET", "api/v2/public/get_funding_rate_history", query)(client)
end

function funding_rate(client::DeribitClient = Deribit.Common.public_client; kw...)
    return funding_rate(client, FundingRateQuery(; kw...))
end

end
