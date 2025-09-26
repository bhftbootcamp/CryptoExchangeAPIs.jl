module Statistics

export StatisticsQuery,
    StatisticsData,
    statistics

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstrumentType OPTION SPOT PERPETUAL

Base.@kwdef struct StatisticsQuery <: AevoPublicQuery
    asset::String
    instrument_type::InstrumentType.T
    end_time::Maybe{DateTime} = nothing
end

struct OpenInterest <: AevoData
    calls::Maybe{Float64}
    puts::Maybe{Float64}
    total::Float64
end

struct StatisticsData <: AevoData
    asset::String
    open_interest::OpenInterest
    daily_volume::Float64
    daily_buy_volume::Maybe{Float64}
    daily_sell_volume::Maybe{Float64}
    daily_volume_premium::Maybe{Float64}
    total_volume::Float64
    total_volume_premium::Maybe{Float64}
    daily_volume_contracts::Float64
    index_price::Float64
    index_daily_change::Float64
    mark_price::Maybe{Float64}
    mark_price_24h_ago::Maybe{Float64}
    mark_daily_change::Maybe{Float64}
    funding_daily_avg::Maybe{Float64}
    put_call_ratio::Maybe{Float64}
end

"""
    statistics(client::AevoClient, query::StatisticsQuery)
    statistics(client::AevoClient = Aevo.Futures.public_client; kw...)

Returns the market statistics for the given asset.

[`GET statistics`](https://api-docs.aevo.xyz/reference/getstatistics)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Aevo

result = Aevo.Futures.statistics(; 
    asset = "ETH",
    instrument_type = Aevo.Futures.Statistics.PERPETUAL,
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
function statistics(client::AevoClient, query::StatisticsQuery)
    return APIsRequest{StatisticsData}("GET", "statistics", query)(client)
end

function statistics(client::AevoClient = Aevo.public_client; kw...)
    return statistics(client, StatisticsQuery(; kw...))
end

end