module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Deribit
using CryptoAPIs.Deribit: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: DeribitPublicQuery
    instrument_name::String
end

struct Greeks <: DeribitData
    delta::Float64
    gamma::Float64
    rho::Float64
    theta::Float64
    vega::Float64
end

struct Stats <: DeribitData
    high::Maybe{Float64}
    low::Maybe{Float64}
    price_change::Maybe{Float64}
    volume::Float64
    volume_usd::Float64
end

struct TickerData <: DeribitData
    ask_iv::Maybe{Float64}
    best_ask_amount::Maybe{Float64}
    best_ask_price::Maybe{Float64}
    best_bid_amount::Maybe{Float64}
    best_bid_price::Maybe{Float64}
    bid_iv::Maybe{Float64}
    current_funding::Maybe{Float64}
    delivery_price::Maybe{Float64}
    estimated_delivery_price::Maybe{Float64}
    funding_8h::Maybe{Float64}
    greeks::Maybe{Greeks}
    index_price::Maybe{Float64}
    instrument_name::String
    interest_rate::Maybe{Float64}
    interest_value::Maybe{Float64}
    last_price::Maybe{Float64}
    mark_iv::Maybe{Float64}
    mark_price::Maybe{Float64}
    max_price::Maybe{Float64}
    min_price::Maybe{Float64}
    open_interest::Maybe{Float64}
    settlement_price::Maybe{Float64}
    state::Maybe{String}
    stats::Maybe{Stats}
    timestamp::NanoDate
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
end

function Serde.deser(::Type{TickerData}, ::Type{Maybe{Float64}}, x::String)
    return x == "expired" ? NaN : parse(Float64, x)
end

"""
    ticker(client::DeribitClient, query::TickerQuery)
    ticker(client::DeribitClient = Deribit.Common.public_client; kw...)

Get ticker for an instrument.

[`GET api/v2/public/ticker`](https://docs.deribit.com/#public-ticker)

## Parameters:

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| instrument_name | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Deribit

result = Deribit.Common.ticker(;
    instrument_name = "BTC-PERPETUAL",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":null,
  "jsonrpc":"2.0",
  "testnet":false,
  "usDiff":209,
  "usOut":"2024-05-17T12:10:28.639980032",
  "usIn":"2024-05-17T12:10:28.639770880",
  "result":{
    "ask_iv":null,
    "best_ask_amount":227380.0,
    "best_ask_price":66265.0,
    "best_bid_amount":27200.0,
    "best_bid_price":66264.5,
    "bid_iv":null,
    "current_funding":2.428e-5,
    "delivery_price":null,
    "estimated_delivery_price":66245.52,
    "funding_8h":2.703e-5,
    "greeks":null,
    "index_price":66245.52,
    "instrument_name":"BTC-PERPETUAL",
    "interest_rate":null,
    "interest_value":0.011170326646787519,
    "last_price":66265.0,
    "mark_iv":null,
    "mark_price":66263.69,
    "max_price":68252.0,
    "min_price":64275.5,
    "open_interest":7.0092983e8,
    "settlement_price":66421.48,
    "state":"open",
    "stats":{
      "high":66798.0,
      "low":64620.5,
      "price_change":-0.0121,
      "volume":9331.58638298,
      "volume_usd":6.139311e8
    },
    "timestamp":"2024-05-17T12:10:28.576",
    "underlying_index":null,
    "underlying_price":null
  }
}
```
"""
function ticker(client::DeribitClient, query::TickerQuery)
    return APIsRequest{Data{TickerData}}("GET", "api/v2/public/ticker", query)(client)
end

function ticker(client::DeribitClient = Deribit.Common.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
