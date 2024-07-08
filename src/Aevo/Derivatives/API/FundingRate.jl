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

Returns the market statistics for the given asset.

[`GET funding-history`](https://api-docs.aevo.xyz/reference/getfundinghistory)

## Code samples:

```julia
using Serde
using CryptoAPIs.Aevo

result = Aevo.Derivatives.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Derivatives.FundingRate.PERPETUAL,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asset":"ETH",
  "open_interest":{
    "total":2678.156722
  },
  "daily_volume":2.0555100110632844e7,
  "daily_buy_volume":9.661439151821265e6,
  "daily_sell_volume":1.0893660958811581e7,
  "daily_volume_premium":null,
  "total_volume":17795.39194288,
  "total_volume_premium":null,
  "daily_volume_contracts":6942.52,
  "index_price":2973.386837,
  "index_daily_change":14.858767,
  "mark_price":2972.9028,
  "mark_price_24h_ago":2964.452868,
  "mark_daily_change":8.449932,
  "funding_daily_avg":-4.0e-6,
  "put_call_ratio":null
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