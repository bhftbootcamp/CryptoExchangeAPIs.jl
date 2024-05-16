module CurrencyV2

export CurrencyV2Query,
    CurrencyV2Data,
    currency_v2

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Poloniex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrencyV2Query <: PoloniexPublicQuery
    # ... empty
end

struct Network <: PoloniexData
    id::Int64
    coin::String
    name::Maybe{String}
    currencyType::String
    blockchain::Maybe{String}
    withdrawalEnable::Bool
    depositEnable::Bool
    depositAddress::Maybe{String}
    withdrawMin::Float64
    decimals::Float64
    withdrawFee::Float64
    minConfirm::Int64
end

struct CurrencyV2Data <: PoloniexData
    id::Int64
    coin::String
    delisted::Bool
    tradeEnable::Bool
    name::String
    networkList::Vector{Network}
    supportCollateral::Maybe{Bool}
    supportBorrow::Maybe{Bool}
end

"""
    currency_v2(client::PoloniexClient, query::CurrencyV2Query)
    currency_v2(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get all supported currencies.

[`GET v2/currencies`](https://api-docs.poloniex.com/spot/api/public/reference-data#currencyv2-information)

## Code samples:

```julia
using Serde
using CryptoAPIs.Poloniex

result = Poloniex.Spot.currency_v2()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":446,
    "coin":"AAVE",
    "delisted":false,
    "tradeEnable":true,
    "name":"Aave",
    "networkList":[
      {
        "id":446,
        "coin":"AAVE",
        "name":"Ethereum",
        "currencyType":"address",
        "blockchain":"ETH",
        "withdrawalEnable":true,
        "depositEnable":true,
        "depositAddress":null,
        "withdrawMin":-1.0,
        "decimals":8.0,
        "withdrawFee":0.0946982,
        "minConfirm":64
      }
    ],
    "supportCollateral":false,
    "supportBorrow":false
  },
  ...
]
```
"""
function currency_v2(client::PoloniexClient, query::CurrencyV2Query)
    return APIsRequest{Vector{CurrencyV2Data}}("GET", "v2/currencies", query)(client)
end

function currency_v2(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return currency_v2(client, CurrencyV2Query(; kw...))
end

end