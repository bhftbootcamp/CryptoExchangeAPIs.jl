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
    name::Maybe{String}
    type::Maybe{String}
    quanto_multiplier::Maybe{String}
    leverage_min::Maybe{String}
    leverage_max::Maybe{String}
    maintenance_rate::Maybe{String}
    mark_type::Maybe{String}
    mark_price::Maybe{String}
    index_price::Maybe{String}
    last_price::Maybe{String}
    maker_fee_rate::Maybe{String}
    taker_fee_rate::Maybe{String}
    order_price_round::Maybe{String}
    mark_price_round::Maybe{String}
    funding_rate::Maybe{String}
    funding_interval::Maybe{Int64}
    funding_next_apply::Maybe{Float64}
    risk_limit_base::Maybe{String}
    risk_limit_step::Maybe{String}
    risk_limit_max::Maybe{String}
    order_size_min::Maybe{Int64}
    order_size_max::Maybe{Int64}
    order_price_deviate::Maybe{String}
    ref_discount_rate::Maybe{String}
    ref_rebate_rate::Maybe{String}
    orderbook_id::Maybe{Int64}
    trade_id::Maybe{Int64}
    trade_size::Maybe{Int64}
    position_size::Maybe{Int64}
    config_change_time::Maybe{Float64}
    in_delisting::Maybe{Bool}
    orders_limit::Maybe{Int64}
    enable_bonus::Maybe{Bool}
    enable_credit::Maybe{Bool}
    create_time::Maybe{Float64}
    funding_cap_ratio::Maybe{String}
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
    "quanto_multiplier":"0",
    "leverage_min":"1",
    "leverage_max":"100",
    "maintenance_rate":"0.005",
    "mark_type":"index",
    "mark_price":"63440.66",
    "index_price":"63437.21",
    "last_price":"63406.2",
    "maker_fee_rate":"-0.0002",
    "taker_fee_rate":"0.00075",
    "order_price_round":"0.1",
    "mark_price_round":"0.01",
    "funding_rate":"0.0001",
    "funding_interval":28800,
    "funding_next_apply":1.7132256e9,
    "risk_limit_base":"100",
    "risk_limit_step":"100",
    "risk_limit_max":"800",
    "order_size_min":1,
    "order_size_max":1000000,
    "order_price_deviate":"0.5",
    "ref_discount_rate":"0",
    "ref_rebate_rate":"0.2",
    "orderbook_id":4464237107,
    "trade_id":42779627,
    "trade_size":57536481481,
    "position_size":12413281,
    "config_change_time":1.692326979e9,
    "in_delisting":false,
    "orders_limit":50,
    "enable_bonus":false,
    "enable_credit":true,
    "create_time":0.0,
    "funding_cap_ratio":"0.75"
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