module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickersQuery <: GateioPublicQuery
    currency_pair::Maybe{String} = nothing
    timezone::Maybe{String} = nothing
end

struct TickersData <: GateioData
    currency_pair::String
    base_volume::Maybe{Float64}
    change_percentage::Float64
    change_utc0::Maybe{Float64}
    change_utc8::Maybe{Float64}
    etf_leverage::Maybe{Float64}
    etf_net_value::Maybe{Float64}
    etf_pre_net_value::Maybe{Float64}
    etf_pre_timestamp::Maybe{NanoDate}
    high_24h::Maybe{Float64}
    highest_bid::Maybe{Float64}
    last::Maybe{Float64}
    low_24h::Maybe{Float64}
    lowest_ask::Maybe{Float64}
    quote_volume::Maybe{Float64}
end

function Serde.isempty(::Type{TickersData}, x)::Bool
    return x === ""
end

"""
    tickers(client::GateioClient, query::TickersQuery)
    tickers(client::GateioClient = Gateio.public_client; kw...)

Retrieve ticker information.

[`GET api/v4/spot/tickers`](https://www.gate.io/docs/developers/apiv4/#retrieve-ticker-information)

## Parameters:

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| currency_pair | String     | false    |             |
| timezone      | String     | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Spot.tickers(;
    currency_pair = "ADA_USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "currency_pair":"ADA_USDT",
    "base_volume":2.0167711540647e7,
    "change_percentage":-4.77,
    "change_utc0":null,
    "change_utc8":null,
    "etf_leverage":null,
    "etf_net_value":null,
    "etf_pre_net_value":null,
    "etf_pre_timestamp":null,
    "high_24h":0.623,
    "highest_bid":0.5869,
    "last":0.5869,
    "low_24h":0.5721,
    "lowest_ask":0.587,
    "quote_volume":1.1922473751288e7
  }
]
```
"""
function tickers(client::GateioClient, query::TickersQuery)
    return APIsRequest{Vector{TickersData}}("GET", "api/v4/spot/tickers", query)(client)
end

function tickers(client::GateioClient = Gateio.public_client; kw...)
    return tickers(client, TickersQuery(; kw...))
end

end
