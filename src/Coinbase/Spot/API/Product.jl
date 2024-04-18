module Product

export ProductQuery,
    ProductData,
    product

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Coinbase
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct ProductQuery <: CoinbasePublicQuery
    type::Maybe{String} = nothing
end
struct ProductData <: CoinbaseData
    id::String
    base_currency::Maybe{String}
    quote_currency::Maybe{String}
    quote_increment::Maybe{Float64}
    base_increment::Maybe{Float64}
    display_name::Maybe{String}
    min_market_funds::Maybe{Float64}
    margin_enabled::Maybe{Bool}
    post_only::Maybe{Bool}
    limit_only::Maybe{Bool}
    cancel_only::Maybe{Bool}
    status::Maybe{String}
    status_message::Maybe{String}
    trading_disabled::Maybe{Bool}
    fx_stablecoin::Maybe{Bool}
    max_slippage_percentage::Maybe{Float64}
    auction_mode::Maybe{Bool}
    high_bid_limit_percentage::Maybe{Float64}
end

function Serde.isempty(::Type{<:ProductData}, x)::Bool
    return x === ""
end

"""
    product(client::CoinbaseClient, query::ProductQuery)
    product(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)

Gets a list of available currency pairs for trading.

[`GET products`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproducts)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| type      | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Coinbase

result = Coinbase.Spot.product(;
    type = "ADA-USDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":"BCH-GBP",
    "base_currency":"BCH",
    "quote_currency":"GBP",
    "quote_increment":0.01,
    "base_increment":1.0e-8,
    "display_name":"BCH-GBP",
    "min_market_funds":0.72,
    "margin_enabled":false,
    "post_only":false,
    "limit_only":false,
    "cancel_only":false,
    "status":"online",
    "status_message":null,
    "trading_disabled":false,
    "fx_stablecoin":false,
    "max_slippage_percentage":0.03,
    "auction_mode":false,
    "high_bid_limit_percentage":null
  },
  ...
]
```
"""
function product(client::CoinbaseClient, query::ProductQuery)
    return APIsRequest{Vector{ProductData}}("GET", "products", query)(client)
end

function product(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)
    return product(client, ProductQuery(; kw...))
end

end
