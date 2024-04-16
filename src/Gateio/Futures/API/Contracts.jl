module Contracts

export ContractsQuery,
    ContractsData,
    contracts

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct ContractsQuery <: GateioPublicQuery
    limit::Maybe{Int64} = nothing
    offset::Maybe{Int64} = nothing
end

struct ContractsData <: GateioData
    name::String
    type::String
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
    funding_next_apply::Maybe{Int64}
    short_users::Maybe{Int64}
    config_change_time::Maybe{Int64}
    trade_size::Maybe{Int64}
    position_size::Maybe{Int64}
    long_users::Maybe{Int64}
    funding_impact_value::Maybe{Float64}
    orders_limit::Maybe{Int64}
    trade_id::Maybe{Int64}
    orderbook_id::Maybe{Int64}
    enable_bonus::Maybe{Bool}
    enable_credit::Maybe{Bool}
    create_time::Maybe{Int64}
    funding_cap_ratio::Maybe{Float64}
end

"""
    contracts(client::GateioClient, query::ContractsQuery)
    contracts(client::GateioClient = Gateio.Futures.public_client; kw...)

List all currencies' details.

[`GET api/v4/futures/{settle}/contracts`](https://www.gate.io/docs/developers/apiv4/en/#list-all-futures-contracts)

## Code samples:

```julia
using Serde
using CryptoAPIs.Gateio

result = Gateio.Futures.contracts(; settle = "btc")

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "name":"BTC_USD",
    "type":"inverse",
    "quanto_multiplier":0.0,
    "ref_discount_rate":0.0,
    "order_price_deviate":0.5,
    "maintenance_rate":0.005,
    "mark_type":"index",
    "last_price":62543.5,
    "mark_price":62628.97,
    "index_price":62628.44,
    "funding_rate_indicative":1.5e-5,
    "mark_price_round":0.01,
    "funding_offset":0,
    "in_delisting":false,
    "risk_limit_base":100.0,
    "interest_rate":0.0003,
    "order_price_round":0.1,
    "order_size_min":1,
    "ref_rebate_rate":0.2,
    "funding_interval":28800,
    "risk_limit_step":100.0,
    "leverage_min":1.0,
    "leverage_max":100.0,
    "risk_limit_max":800.0,
    "maker_fee_rate":-0.0002,
    "taker_fee_rate":0.00075,
    "funding_rate":1.5e-5,
    "order_size_max":1000000,
    "funding_next_apply":1713283200,
    "short_users":164,
    "config_change_time":1692326979,
    "trade_size":57546798366,
    "position_size":12855226,
    "long_users":540,
    "funding_impact_value":1.0,
    "orders_limit":50,
    "trade_id":42799286,
    "orderbook_id":4466034561,
    "enable_bonus":false,
    "enable_credit":true,
    "create_time":0,
    "funding_cap_ratio":0.75
  }
]
```
"""
function contracts(client::GateioClient, query::ContractsQuery; settle::String)
    return APIsRequest{Vector{ContractsData}}("GET", "api/v4/futures/$settle/contracts", query)(client)
end

function contracts(client::GateioClient = Gateio.Futures.public_client; settle::String, kw...)
    return contracts(client, ContractsQuery(; kw...); settle = settle)
end

end