module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle usdt

Base.@kwdef struct TickersQuery <: GateioPublicQuery
    settle::Settle.T
    contract::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TickersQuery}, ::Val{:settle}) = true

struct TickersData <: GateioData
    contract::String
    last::Float64
    low_24h::Float64
    high_24h::Float64
    change_percentage::Float64
    total_size::Int
    volume_24h::Maybe{Int}
    volume_24h_btc::Maybe{Int}
    volume_24h_usd::Maybe{Int}
    volume_24h_base::Maybe{Int}
    volume_24h_quote::Maybe{Int}
    volume_24h_settle::Maybe{Int}
    mark_price::Float64
    funding_rate::Maybe{Float64}
    funding_rate_indicative::Maybe{Float64}
    index_price::Float64
    highest_bid::Float64
    lowest_ask::Float64
end

"""
    tickers(client::GateioClient, query::TickersQuery)
    tickers(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Get all futures trading statistics.

[`GET api/v4/delivery/{settle}/tickers`](https://www.gate.com/docs/developers/apiv4/en/#get-all-futures-trading-statistics-2)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| settle    | Settle   | true     | usdt        |
| contract  | String   | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Delivery.tickers(;
    settle = Gateio.API.V4.Delivery.Tickers.Settle.usdt,
)
```
"""
function tickers(client::GateioClient, query::TickersQuery)
    return APIsRequest{Vector{TickersData}}("GET", "api/v4/delivery/$(query.settle)/tickers", query)(client)
end

function tickers(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return tickers(client, TickersQuery(; kw...))
end

end
