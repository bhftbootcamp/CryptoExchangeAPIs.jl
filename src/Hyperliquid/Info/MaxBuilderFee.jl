module MaxBuilderFee

export MaxBuilderFeeQuery,
    MaxBuilderFeeData,
    max_builder_fee

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MaxBuilderFeeQuery <: HyperliquidPublicQuery
    type::String = "maxBuilderFee"
    user::String
    builder::String
end

const MaxBuilderFeeData = Int

"""
    max_builder_fee(client::HyperliquidClient, query::MaxBuilderFeeQuery)
    max_builder_fee(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Check builder fee approval. Returns maximum fee approved in tenths of a basis point (e.g. 1 means 0.001%).

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#check-builder-fee-approval)

## Parameters:

| Parameter | Type   | Required | Description                                    |
|:----------|:-------|:---------|:-----------------------------------------------|
| user      | String | true     | Address in 42-character hexadecimal format     |
| builder   | String | true     | Builder address in 42-character hex format     |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.max_builder_fee(;
    user = "0x0000000000000000000000000000000000000000",
    builder = "0x0000000000000000000000000000000000000001"
)
```
"""
function max_builder_fee(client::HyperliquidClient, query::MaxBuilderFeeQuery)
    return APIsRequest{MaxBuilderFeeData}("POST", "info", query)(client)
end

function max_builder_fee(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return max_builder_fee(client, MaxBuilderFeeQuery(; kw...))
end

end

