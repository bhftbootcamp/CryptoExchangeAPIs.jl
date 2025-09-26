module Tickers

export TickersQuery,
    TickersData,
    tickers

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt usd

Base.@kwdef struct TickersQuery <: GateioPublicQuery
    settle::Settle.T
    contract::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{TickersQuery}, ::Val{:settle}) = true

struct TickersData <: GateioData
    contract::String
    last::Maybe{Float64}
    low_24h::Maybe{Float64}
    high_24h::Maybe{Float64}
    change_percentage::Maybe{Float64}
    total_size::Maybe{Int64}
    volume_24h::Maybe{Int64}
    volume_24h_btc::Maybe{Int64}
    volume_24h_usd::Maybe{Int64}
    volume_24h_base::Maybe{Int64}
    volume_24h_quote::Maybe{Int64}
    volume_24h_settle::Maybe{Int64}
    mark_price::Maybe{Float64}
    funding_rate::Maybe{Float64}
    funding_rate_indicative::Maybe{Float64}
    index_price::Maybe{Float64}
    highest_bid::Maybe{Float64}
    lowest_ask::Maybe{Float64}
end

"""
    tickers(client::GateioClient, query::TickersQuery)
    tickers(client::GateioClient = Gateio.public_client; kw...)

List futures tickers.

[`GET api/v4/futures/{settle}/tickers`](https://www.gate.io/docs/developers/apiv4/en/#list-futures-tickers)

## Parameters:

| Parameter | Type     | Required | Description  |
|:----------|:---------|:---------|:-------------|
| settle    | Settle   | true     | btc usdt usd |
| contract  | String   | false    |              |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.tickers(;
    settle = Gateio.API.V4.Futures.Tickers.Settle.btc,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "contract":"BTC_USD",
    "last":62157.4,
    "low_24h":61568.7,
    "high_24h":64746.7,
    "change_percentage":-3.12,
    "total_size":12791802,
    "volume_24h":21362145,
    "volume_24h_btc":343,
    "volume_24h_usd":21362145,
    "volume_24h_base":343,
    "volume_24h_quote":21362145,
    "volume_24h_settle":343,
    "mark_price":62221.82,
    "funding_rate":0.0001,
    "funding_rate_indicative":0.0001,
    "index_price":62216.21,
    "highest_bid":62129.9,
    "lowest_ask":62133.1
  }
]
```
"""
function tickers(client::GateioClient, query::TickersQuery)
    return APIsRequest{Vector{TickersData}}("GET", "api/v4/futures/$(query.settle)/tickers", query)(client)
end

function tickers(client::GateioClient = Gateio.public_client; kw...)
    return tickers(client, TickersQuery(; kw...))
end

end
