module Tickers

export TickersQuery,
    TickersData,
    tickers

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

@enumx DeliveryStatus begin
    delivery_config_period
    delivery_normal
    delivery_before
    delivery_period
end

Base.@kwdef struct TickersQuery <: BitgetPublicQuery
    productType::SettleType.T
end

function Serde.SerQuery.ser_type(::Type{TickersQuery}, x::SettleType.T)
    x == SettleType.USDT_FUTURES && return "USDT-FUTURES"
    x == SettleType.USDC_FUTURES && return "USDC-FUTURES"
    x == SettleType.COIN_FUTURES && return "COIN-FUTURES"
end

struct TickersData <: BitgetData
    symbol::String
    lastPr::Float64
    askPr::Float64
    bidPr::Float64
    bidSz::Float64
    askSz::Float64
    high24h::Float64
    low24h::Float64
    ts::NanoDate
    change24h::Float64
    baseVolume::Float64
    quoteVolume::Float64
    usdtVolume::Float64
    openUtc::Float64
    changeUtc24h::Float64
    indexPrice::Maybe{Float64}
    fundingRate::Float64
    holdingAmount::Float64
    deliveryStartTime::Maybe{NanoDate}
    deliveryTime::Maybe{NanoDate}
    deliveryStatus::Maybe{DeliveryStatus.T}
    open24h::Float64
    markPrice::Float64
end

"""
    tickers(client::BitgetClient, query::TickersQuery)
    tickers(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get ticker information, supporting both single and batch queries.

[`GET api/v2/mix/market/tickers`](https://www.bitget.com/api-doc/contract/market/Get-All-Symbol-Ticker)

## Parameters:

| Parameter   | Type       | Required | Description                                  |
|:------------|:-----------|:---------|:---------------------------------------------|
| productType | SettleType | true     | USDT\\_FUTURES USDC\\_FUTURES COIN\\_FUTURES |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V2.Mix.Market.tickers(
    productType = Bitget.API.V2.Mix.Market.Tickers.SettleType.USDT_FUTURES,
)
```
"""
function tickers(client::BitgetClient, query::TickersQuery)
    return APIsRequest{Data{Vector{TickersData}}}("GET", "api/v2/mix/market/tickers", query)(client)
end

function tickers(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return tickers(client, TickersQuery(; kw...))
end

end
