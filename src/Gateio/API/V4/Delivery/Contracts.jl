module Contracts

export ContractsQuery,
    ContractsData,
    contracts

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Settle usdt

@enumx ContractType direct inverse

Base.@kwdef struct ContractsQuery <: GateioPublicQuery
    settle::Settle.T
end

Serde.SerQuery.ser_ignore_field(::Type{ContractsQuery}, ::Val{:settle}) = true

struct ContractsData <: GateioData
    name::String
    underlying::String
    cycle::String
    type::ContractType.T
    quanto_multiplier::Float64
    mark_price::Float64
    last_price::Float64
    index_price::Float64
    basis_rate::Float64
    basis_value::Float64
    basis_impact_value::Float64
    settle_price::Float64
    settle_price_interval::Int
    settle_price_duration::Int
    settle_fee_rate::Float64
    expire_time::NanoDate
    order_price_round::Float64
    mark_price_round::Float64
    leverage_min::Float64
    leverage_max::Float64
    maintenance_rate::Float64
    risk_limit_base::Float64
    risk_limit_step::Float64
    risk_limit_max::Float64
    maker_fee_rate::Float64
    taker_fee_rate::Float64
    ref_discount_rate::Float64
    ref_rebate_rate::Float64
    order_price_deviate::Float64
    order_size_min::Int
    order_size_max::Int
    orders_limit::Int
    orderbook_id::Int
    trade_id::Int
    trade_size::Int
    position_size::Int
    config_change_time::NanoDate
    in_delisting::Bool
end

"""
    contracts(client::GateioClient, query::ContractsQuery)
    contracts(client::GateioClient = Gateio.GateioClient(Gateio.public_config); kw...)

Query all futures contracts.

[`GET api/v4/delivery/{settle}/contracts`](https://www.gate.com/docs/developers/apiv4/en/#query-all-futures-contracts-2)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| settle    | Settle   | true     | usdt        |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Delivery.contracts(;
    settle = Gateio.API.V4.Delivery.Contracts.Settle.usdt,
)
```
"""
function contracts(client::GateioClient, query::ContractsQuery)
    return APIsRequest{Vector{ContractsData}}("GET", "api/v4/delivery/$(query.settle)/contracts", query)(client)
end

function contracts(
    client::GateioClient = Gateio.GateioClient(Gateio.public_config);
    kw...,
)
    return contracts(client, ContractsQuery(; kw...))
end

end
