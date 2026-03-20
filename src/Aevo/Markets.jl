module Markets

export MarketsQuery,
    MarketData,
    markets

using EnumX
using Dates, NanoDates
using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstrumentType OPTION SPOT PERPETUAL

@enumx OptionType put call

Base.@kwdef struct MarketsQuery <: AevoPublicQuery
    asset::Maybe{String} = nothing
    instrument_type::Maybe{InstrumentType.T} = nothing
end

struct MarketData <: AevoData
    instrument_id::String
    instrument_name::String
    instrument_type::InstrumentType.T
    underlying_asset::String
    quote_asset::String
    price_step::Float64
    amount_step::Float64
    min_order_value::Float64
    max_order_value::Float64
    max_notional_value::Float64
    price_band::Float64
    mark_price::Float64
    forward_price::Maybe{Float64}
    index_price::Float64
    is_active::Bool
    option_type::Maybe{OptionType.T}
    expiry::Maybe{NanoDate}
    strike::Maybe{Float64}
    max_leverage::Maybe{Float64}
    is_rwa::Bool
    market_type::String
    pre_launch::Maybe{Bool}
end

"""
    markets(client::AevoClient, query::MarketsQuery)
    markets(client::AevoClient = Aevo.AevoClient(Aevo.public_config); kw...)

Returns a list of instruments. If `asset` is not specified, the response includes all listed instruments.

[`GET markets`](https://api-docs.aevo.xyz/reference/getmarkets)

## Parameters

| Parameter       | Type   | Required | Description |
|:----------------|:-------|:---------|:------------|
| asset           | String | false    |             |
| instrument_type | String | false    |             |

## Code samples

```julia
using CryptoExchangeAPIs.Aevo

result = Aevo.markets()
```
"""
function markets(client::AevoClient, query::MarketsQuery)
    return APIsRequest{Vector{MarketData}}("GET", "markets", query)(client)
end

function markets(
    client::AevoClient = Aevo.AevoClient(Aevo.public_config);
    kw...,
)
    return markets(client, MarketsQuery(; kw...))
end

end
