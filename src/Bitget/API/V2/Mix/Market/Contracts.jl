module Contracts

export ContractsQuery,
    ContractsData,
    contracts

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx SettleType begin
    USDT_FUTURES
    USDC_FUTURES
    COIN_FUTURES
end

@enumx Status begin
    listed
    normal
    maintain
    limit_open
    restrictedAPI
    off
end

@enumx DeliveryPeriod this_quarter next_quarter

@enumx ExpiryType perpetual delivery

Base.@kwdef struct ContractsQuery <: BitgetPublicQuery
    symbol::Maybe{String} = nothing
    productType::SettleType.T
end

function Serde.SerQuery.ser_type(::Type{ContractsQuery}, x::SettleType.T)
    x == SettleType.USDT_FUTURES && return "USDT-FUTURES"
    x == SettleType.USDC_FUTURES && return "USDC-FUTURES"
    x == SettleType.COIN_FUTURES && return "COIN-FUTURES"
end

struct ContractsData <: BitgetData
    symbol::String
    baseCoin::String
    quoteCoin::String
    buyLimitPriceRatio::Float64
    sellLimitPriceRatio::Float64
    feeRateUpRatio::Float64
    makerFeeRate::Float64
    takerFeeRate::Float64
    openCostUpRatio::Float64
    supportMarginCoins::Vector{String}
    minTradeNum::Float64
    priceEndStep::Float64
    volumePlace::Int
    pricePlace::Int
    sizeMultiplier::Float64
    symbolType::ExpiryType.T
    minTradeUSDT::Float64
    maxSymbolOrderNum::Int
    maxProductOrderNum::Int
    maxPositionNum::Int
    symbolStatus::Status.T
    offTime::Maybe{NanoDate}
    limitOpenTime::Maybe{NanoDate}
    deliveryTime::Maybe{NanoDate}
    deliveryStartTime::Maybe{NanoDate}
    deliveryPeriod::Maybe{DeliveryPeriod.T}
    launchTime::Maybe{NanoDate}
    fundInterval::Maybe{Int}
    minLever::Int
    maxLever::Int
    posLimit::Maybe{Float64}
    maintainTime::Maybe{NanoDate}
    maxMarketOrderQty::Maybe{Float64}
    maxOrderQty::Maybe{Float64}
    isRwa::Bool
end

function Serde.deser(::Type{ContractsData}, ::Type{Bool}, s::String)
    uppercase(s) == "YES" && return true
    uppercase(s) == "NO" && return false
    throw(ArgumentError("invalid boolean string: $(s)"))
end

"""
    contracts(client::BitgetClient, query::ContractsQuery)
    contracts(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Interface is used to get future contract details.

[`GET api/v2/mix/market/contracts`](https://www.bitget.com/api-doc/contract/market/Get-All-Symbols-Contracts)

## Parameters:

| Parameter   | Type       | Required | Description                                  |
|:------------|:-----------|:---------|:---------------------------------------------|
| symbol      | String     | false    |                                              |
| productType | SettleType | true     | USDT\\_FUTURES USDC\\_FUTURES COIN\\_FUTURES |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V2.Mix.Market.contracts(
    productType = Bitget.API.V2.Mix.Market.Contracts.SettleType.USDT_FUTURES
)

result = Bitget.API.V2.Mix.Market.contracts(
    productType = Bitget.API.V2.Mix.Market.Contracts.SettleType.USDT_FUTURES,
    symbol = "BTCUSDT",
)
```
"""
function contracts(client::BitgetClient, query::ContractsQuery)
    return APIsRequest{Data{Vector{ContractsData}}}("GET", "api/v2/mix/market/contracts", query)(client)
end

function contracts(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return contracts(client, ContractsQuery(; kw...))
end

end
