module Currency

export CurrencyQuery,
    CurrencyData,
    currency

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Poloniex
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CurrencyQuery <: PoloniexPublicQuery
    includeMultiChainCurrency::Maybe{Bool} = false
end

@enum TradingState NORMAL OFFLINE

@enum WalletStatus ENABLED DISABLED

struct CurrencyData <: PoloniexData
    blockchain::Maybe{String}
    childChains::Maybe{Vector{String}}
    delisted::Bool
    depositAddress::Maybe{String}
    description::String
    id::Int64
    isChildChain::Maybe{Bool}
    isMultiChain::Maybe{Bool}
    minConf::Int64
    name::String
    parentChain::Maybe{String}
    supportBorrow::Maybe{Bool}
    supportCollateral::Maybe{Bool}
    tradingState::TradingState
    type::String
    walletDepositState::WalletStatus
    walletState::WalletStatus
    walletWithdrawalState::WalletStatus
    withdrawalFee::Float64
end

"""
    currency(client::PoloniexClient, query::CurrencyQuery)
    currency(client::PoloniexClient = Poloniex.Spot.public_client; kw...)

Get all supported currencies.

[`GET currencies`](https://api-docs.poloniex.com/spot/api/public/reference-data#currency-information)

## Parameters:

| Parameter | Type         | Required | Description |
|:----------|:-------------|:---------|:------------|
|includeMultiChainCurrency | Bool | false |         |

## Code samples:

```julia
using Serde
using CryptoAPIs.Poloniex

result = Poloniex.Spot.currency()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "AAVE":{
      "blockchain":"ETH",
      "childChains":null,
      "delisted":false,
      "depositAddress":null,
      "description":"Sweep to Main Account",
      "id":446,
      "isChildChain":null,
      "isMultiChain":null,
      "minConf":64,
      "name":"Aave",
      "parentChain":null,
      "supportBorrow":false,
      "supportCollateral":false,
      "tradingState":"NORMAL",
      "type":"address",
      "walletDepositState":"ENABLED",
      "walletState":"ENABLED",
      "walletWithdrawalState":"ENABLED",
      "withdrawalFee":0.0946982
    }
  },
  ...
]
```
"""
function currency(client::PoloniexClient, query::CurrencyQuery)
    return APIsRequest{Vector{Dict{String,CurrencyData}}}("GET", "currencies", query)(client)
end

function currency(client::PoloniexClient = Poloniex.Spot.public_client; kw...)
    return currency(client, CurrencyQuery(; kw...))
end

end
