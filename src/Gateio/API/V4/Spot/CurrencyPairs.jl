module CurrencyPairs

export CurrencyPairsQuery,
    currency_pairs

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx TradeStatus untradable buyable sellable tradable

Base.@kwdef struct CurrencyPairsQuery <: GateioPublicQuery
    currency_pair::Maybe{String} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{CurrencyPairsQuery}, ::Val{:currency_pair}) = true

struct CurrencyPairData <: GateioData
    id::String
    base::String
    base_name::String
    var"quote"::String
    quote_name::String
    fee::Maybe{Float64}
    min_base_amount::Maybe{Float64}
    min_quote_amount::Maybe{Float64}
    max_base_amount::Maybe{Float64}
    max_quote_amount::Maybe{Float64}
    amount_precision::Int64
    precision::Int64
    trade_status::TradeStatus.T
    sell_start::Maybe{NanoDate}
    buy_start::Maybe{NanoDate}
    delisting_time::Maybe{NanoDate}
    type::String
    trade_url::String
    st_tag::Bool
    up_rate::Maybe{Float64}
    down_rate::Maybe{Float64}
    slippage::Maybe{Float64}
    max_market_order_stock::Maybe{Float64}
    max_market_order_money::Maybe{Float64}
end

"""
    currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    currency_pairs(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

List all currency pairs supported, or get details of a specific currency pair.

[`GET /api/v4/spot/currency_pairs`](https://www.gate.io/docs/developers/apiv4/#list-all-currency-pairs-supported)

## Parameters:

| Parameter     | Type   | Required | Description                                         |
|:--------------|:-------|:---------|:----------------------------------------------------|
| currency_pair | String | false    | Currency pair. If provided, returns only that pair. |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

# All pairs
result = Gateio.API.V4.Spot.currency_pairs()

# Single pair
result = Gateio.API.V4.Spot.currency_pairs(; currency_pair = "ETH_BTC")
```
"""
function currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    endpoint = if isnothing(query.currency_pair)
        "api/v4/spot/currency_pairs"
    else
        "api/v4/spot/currency_pairs/$(query.currency_pair)"
    end
    datatype = isnothing(query.currency_pair) ? Vector{CurrencyPairData} : CurrencyPairData
    return APIsRequest{datatype}("GET", endpoint, query)(client)
end

function currency_pairs(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return currency_pairs(client, CurrencyPairsQuery(; kw...))
end

end
