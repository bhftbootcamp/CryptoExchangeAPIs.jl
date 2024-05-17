module CommonSymbol

export CommonSymbolQuery,
    CommonSymbolData,
    common_symbol

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Huobi
using CryptoAPIs.Huobi: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct CommonSymbolQuery <: HuobiPublicQuery
    #__ empty
end

@enum SymbolPartition begin
    main
    innovation
    st
end

@enum SymbolState begin
    online              # Listed, available for trading
    pre_online          # To be online soon
    offline             # De-listed, not available for trading
    suspend             # Suspended for trading
end

struct CommonSymbolData <: HuobiData
    amount_precision::Int64
    api_trading::String
    base_currency::String
    buy_limit_must_less_than::Float64
    buy_market_max_order_value::Float64
    charge_time::Maybe{Time}
    funding_leverage_ratio::Maybe{Int64}
    init_nav::Maybe{Float64}
    leverage_ratio::Maybe{Float64}
    limit_order_max_buy_amt::Float64
    limit_order_max_order_amt::Float64
    limit_order_max_sell_amt::Float64
    limit_order_min_order_amt::Float64
    market_buy_order_rate_must_less_than::Float64
    market_sell_order_rate_must_less_than::Float64
    max_order_amt::Float64
    max_order_value::Maybe{Int64}
    mgmt_fee_rate::Maybe{Float64}
    min_order_amt::Float64
    min_order_value::Float64
    price_precision::Int64
    quote_currency::String
    rebal_threshold::Maybe{Int64}
    rebal_time::Maybe{Time}
    sell_limit_must_greater_than::Float64
    sell_market_max_order_amt::Float64
    sell_market_min_order_amt::Float64
    state::SymbolState
    super_margin_leverage_ratio::Maybe{Int64}
    symbol::String
    symbol_partition::Maybe{SymbolPartition}
    tags::Maybe{String}
    underlying::Maybe{String}
    value_precision::Int64
end

function Serde.deser(::Type{CommonSymbolData}, ::Type{<:Maybe{Time}}, x::AbstractString)::Time
    return Time(x)
end

function Serde.deser(::Type{CommonSymbolData}, ::Type{<:SymbolState}, x::AbstractString)::SymbolState
    x == "online"     && return online
    x == "pre-online" && return pre_online
    x == "offline"    && return offline
    x == "suspend"    && return suspend
end

"""
    common_symbol(client::HuobiClient, query::CommonSymbolQuery)
    common_symbol(client::HuobiClient = Huobi.Spot.public_client; kw...)

This endpoint returns all Huobi's supported tradable symbols.

[`GET v1/common/symbols`](https://huobiapi.github.io/docs/spot/v1/en/#get-all-supported-trading-symbol-v1-deprecated)

## Code samples:

```julia
using Serde
using CryptoAPIs.Huobi

result = Huobi.Spot.common_symbol()

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "ch":null,
  "ts":null,
  "code":null,
  "data":[
    {
      "amount_precision":4,
      "api_trading":"enabled",
      "base_currency":"xmr",
      "buy_limit_must_less_than":1.1,
      "buy_market_max_order_value":100.0,
      "charge_time":null,
      "funding_leverage_ratio":null,
      "init_nav":null,
      "leverage_ratio":null,
      "limit_order_max_buy_amt":5000.0,
      "limit_order_max_order_amt":5000.0,
      "limit_order_max_sell_amt":5000.0,
      "limit_order_min_order_amt":0.0001,
      "market_buy_order_rate_must_less_than":0.1,
      "market_sell_order_rate_must_less_than":0.1,
      "max_order_amt":5000.0,
      "max_order_value":null,
      "mgmt_fee_rate":null,
      "min_order_amt":0.0001,
      "min_order_value":0.001,
      "price_precision":6,
      "quote_currency":"eth",
      "rebal_threshold":null,
      "rebal_time":null,
      "sell_limit_must_greater_than":0.9,
      "sell_market_max_order_amt":500.0,
      "sell_market_min_order_amt":0.0001,
      "state":"offline",
      "super_margin_leverage_ratio":null,
      "symbol":"xmreth",
      "symbol_partition":"main",
      "tags":"",
      "underlying":null,
      "value_precision":8
    },
    ...
  ]
}
```
"""
function common_symbol(client::HuobiClient, query::CommonSymbolQuery)
    return APIsRequest{Data{Vector{CommonSymbolData}}}("GET", "v1/common/symbols", query)(client)
end

function common_symbol(client::HuobiClient = Huobi.Spot.public_client; kw...)
    return common_symbol(client, CommonSymbolQuery(; kw...))
end

end
