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
    open_interest::Maybe{OpenInterest}
    daily_volume::Maybe{Float64}
    daily_buy_volume::Maybe{Float64}
    daily_sell_volume::Maybe{Float64}
    daily_volume_premium::Maybe{Float64}
    total_volume::Maybe{Float64}
    total_volume_premium::Maybe{Float64}
    daily_volume_contracts::Maybe{Float64}
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
    statistics(client::AevoClient = Aevo.AevoClient(Aevo.public_config); kw...)

Returns the market statistics for the given asset.

[`GET statistics`](https://api-docs.aevo.xyz/reference/getstatistics)

## Code samples:

```julia
using CryptoExchangeAPIs.Aevo

result = Aevo.statistics(; 
    asset = "ETH",
    instrument_type = Aevo.Statistics.InstrumentType.PERPETUAL,
)
```
"""
function statistics(client::AevoClient, query::StatisticsQuery)
    return APIsRequest{StatisticsData}("GET", "statistics", query)(client)
end

function statistics(
    client::AevoClient = Aevo.AevoClient(Aevo.public_config);
    kw...,
)
    return statistics(client, StatisticsQuery(; kw...))
end

end