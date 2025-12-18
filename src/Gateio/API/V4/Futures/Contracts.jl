module Contracts

export ContractsQuery,
    ContractsData,
    contracts

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle btc usdt

@enumx ContractType direct inverse

Base.@kwdef struct ContractsQuery <: GateioPublicQuery
    settle::Settle.T
    limit::Maybe{Int64} = nothing
    offset::Maybe{Int64} = nothing
end

Serde.SerQuery.ser_ignore_field(::Type{ContractsQuery}, ::Val{:settle}) = true

struct ContractsData <: GateioData
    name::String
    type::ContractType.T
    quanto_multiplier::Maybe{Float64}
    ref_discount_rate::Maybe{Float64}
    order_price_deviate::Maybe{Float64}
    maintenance_rate::Maybe{Float64}
    mark_type::String
    last_price::Maybe{Float64}
    mark_price::Maybe{Float64}
    index_price::Maybe{Float64}
    funding_rate_indicative::Maybe{Float64}
    mark_price_round::Maybe{Float64}
    funding_offset::Maybe{Int64}
    in_delisting::Maybe{Bool}
    risk_limit_base::Maybe{Float64}
    interest_rate::Maybe{Float64}
    order_price_round::Maybe{Float64}
    order_size_min::Maybe{Int64}
    ref_rebate_rate::Maybe{Float64}
    funding_interval::Maybe{Int64}
    risk_limit_step::Maybe{Float64}
    leverage_min::Maybe{Float64}
    leverage_max::Maybe{Float64}
    risk_limit_max::Maybe{Float64}
    maker_fee_rate::Maybe{Float64}
    taker_fee_rate::Maybe{Float64}
    funding_rate::Maybe{Float64}
    order_size_max::Maybe{Int64}
    funding_next_apply::Maybe{NanoDate}
    short_users::Maybe{Int64}
    config_change_time::Maybe{NanoDate}
    trade_size::Maybe{Int64}
    position_size::Maybe{Int64}
    long_users::Maybe{Int64}
    funding_impact_value::Maybe{Float64}
    orders_limit::Maybe{Int64}
    trade_id::Maybe{Int64}
    orderbook_id::Maybe{Int64}
    enable_bonus::Maybe{Bool}
    enable_credit::Maybe{Bool}
    create_time::Maybe{NanoDate}
    funding_cap_ratio::Maybe{Float64}
end

"""
    contracts(client::GateioClient, query::ContractsQuery)
    contracts(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

List all futures contracts.

[`GET api/v4/futures/{settle}/contracts`](https://www.gate.io/docs/developers/apiv4/en/#list-all-futures-contracts)

## Parameters:

| Parameter | Type     | Required | Description  |
|:----------|:---------|:---------|:-------------|
| settle    | Settle   | true     | btc usdt usd |
| limit     | Int64    | false    |              |
| offset    | Int64    | false    |              |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Futures.contracts(;
    settle = Gateio.API.V4.Futures.Contracts.Settle.btc,
)
```
"""
function contracts(client::GateioClient, query::ContractsQuery)
    return APIsRequest{Vector{ContractsData}}("GET", "api/v4/futures/$(query.settle)/contracts", query)(client)
end

function contracts(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return contracts(client, ContractsQuery(; kw...))
end

end
