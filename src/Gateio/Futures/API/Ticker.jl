module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: GateioPublicQuery
    contract::Maybe{String} = nothing
end

struct TickerData <: GateioData
    contract::String
    last::Maybe{Float64}
    low_24h::Maybe{Float64}
    high_24h::Maybe{Float64}
    change_percentage::Maybe{Float64}
    total_size::Maybe{Int64}
    volume_24h::Maybe{Float64}
    volume_24h_btc::Maybe{Float64}
    volume_24h_usd::Maybe{Float64}
    volume_24h_base::Maybe{Float64}
    volume_24h_quote::Maybe{Float64}
    volume_24h_settle::Maybe{Float64}
    mark_price::Maybe{Float64}
    funding_rate::Maybe{Float64}
    funding_rate_indicative::Maybe{Float64}
    index_price::Maybe{Float64}
    highest_bid::Maybe{Float64}
    lowest_ask::Maybe{Float64}
end

"""
    ticker(client::GateioClient, query::TickerQuery)
    ticker(client::GateioClient = Gateio.Futures.public_client; kw...)

List futures tickers.

[`GET api/v4/futures/{settle}/tickers`](https://www.gate.io/docs/developers/apiv4/en/#list-futures-tickers)

## Code samples:

```julia
using Serde
using CryptoAPIs.Gateio

result = Gateio.Futures.ticker(; settle = "btc")

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "contract":"BTC_USD",
    "last":62463.6,
    "low_24h":61568.7,
    "high_24h":66376.4,
    "change_percentage":-5.2,
    "total_size":12856564,
    "volume_24h":1.7531128e7,
    "volume_24h_btc":280.0,
    "volume_24h_usd":1.7531128e7,
    "volume_24h_base":280.0,
    "volume_24h_quote":1.7531128e7,
    "volume_24h_settle":280.0,
    "mark_price":62509.05,
    "funding_rate":1.7e-5,
    "funding_rate_indicative":1.7e-5,
    "index_price":62508.43,
    "highest_bid":62452.8,
    "lowest_ask":62458.5
  }
]
```
"""
function ticker(client::GateioClient, query::TickerQuery; settle::String)
    return APIsRequest{Vector{TickerData}}("GET", "api/v4/futures/$settle/tickers", query)(client)
end

function ticker(client::GateioClient = Gateio.Futures.public_client; settle::String, kw...)
    return ticker(client, TickerQuery(; kw...); settle = settle)
end

end