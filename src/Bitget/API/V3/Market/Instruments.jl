module Instruments

export InstrumentsQuery,
    InstrumentData,
    instruments

using Serde
using Dates, NanoDates
using EnumX

using CryptoExchangeAPIs.Bitget
using CryptoExchangeAPIs.Bitget: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category begin
    SPOT
    MARGIN
    USDT_FUTURES
    COIN_FUTURES
    USDC_FUTURES
end

@enumx Status begin
    listed
    online
    limit_open
    limit_close
    offline
    restrictedAPI
end

@enumx InstrumentType perpetual delivery

@enumx DeliveryPeriod this_quarter next_quarter

Base.@kwdef struct InstrumentsQuery <: BitgetPublicQuery
    category::Category.T
    symbol::Maybe{String} = nothing
end

function Serde.SerQuery.ser_type(::Type{InstrumentsQuery}, x::Category.T)
    x == Category.SPOT && return "SPOT"
    x == Category.MARGIN && return "MARGIN"
    x == Category.USDT_FUTURES && return "USDT-FUTURES"
    x == Category.COIN_FUTURES && return "COIN-FUTURES"
    x == Category.USDC_FUTURES && return "USDC-FUTURES"
end

struct InstrumentData <: BitgetData
    symbol::String
    category::Category.T
    baseCoin::String
    quoteCoin::String
    type::Maybe{InstrumentType.T}
    status::Status.T
    launchTime::Maybe{NanoDate}
    offTime::Maybe{NanoDate}
    buyLimitPriceRatio::Float64
    sellLimitPriceRatio::Float64
    feeRateUpRatio::Maybe{Float64}
    openCostUpRatio::Maybe{Float64}
    minOrderQty::Float64
    maxOrderQty::Float64
    pricePrecision::Int
    quantityPrecision::Int
    quotePrecision::Maybe{Int}
    priceMultiplier::Maybe{Float64}
    quantityMultiplier::Maybe{Float64}
    minOrderAmount::Float64
    maxSymbolOrderNum::Maybe{Int}
    maxProductOrderNum::Int
    maxPositionNum::Int
    limitOpenTime::Maybe{NanoDate}
    deliveryTime::Maybe{NanoDate}
    deliveryStartTime::Maybe{NanoDate}
    deliveryPeriod::Maybe{DeliveryPeriod.T}
    fundInterval::Maybe{Int}
    minLeverage::Maybe{Int}
    maxLeverage::Maybe{Int}
    maintainTime::Maybe{NanoDate}
    isIsolatedBaseBorrowable::Maybe{Bool}
    isIsolatedQuotedBorrowable::Maybe{Bool}
    warningRiskRatio::Maybe{Float64}
    liquidationRiskRatio::Maybe{Float64}
    maxCrossedLeverage::Maybe{Float64}
    maxIsolatedLeverage::Maybe{Float64}
    userMinBorrow::Maybe{Float64}
    areaSymbol::Maybe{Bool}
    makerFeeRate::Maybe{Float64}
    takerFeeRate::Maybe{Float64}
    maxMarketOrderQty::Maybe{Float64}
    isRwa::Maybe{Bool}
end

function Serde.deser(::Type{InstrumentData}, ::Type{Category.T}, x::String)
    x == "SPOT" && return Category.SPOT
    x == "MARGIN" && return Category.MARGIN
    x == "USDT-FUTURES" && return Category.USDT_FUTURES
    x == "COIN-FUTURES" && return Category.COIN_FUTURES
    x == "USDC-FUTURES" && return Category.USDC_FUTURES
    throw(ArgumentError("invalid category: $(x)"))
end

function Serde.deser(::Type{InstrumentData}, ::Type{Bool}, s::String)
    uppercase(s) == "YES" && return true
    uppercase(s) == "NO" && return false
    throw(ArgumentError("invalid boolean string: $(s)"))
end

"""
    instruments(client::BitgetClient, query::InstrumentsQuery)
    instruments(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Query the specifications for online trading pair instruments (UTA public API).

[`GET api/v3/market/instruments`](https://www.bitget.com/api-doc/uta/public/Instruments)

## Parameters:

| Parameter | Type     | Required | Description                                                                 |
|:----------|:---------|:---------|:----------------------------------------------------------------------------|
| category  | Category | true     | SPOT MARGIN USDT\\_FUTURES COIN\\_FUTURES USDC\\_FUTURES                    |
| symbol    | String   | false    | Symbol name (e.g. `\"BTCUSDT\"`). If not provided, returns all instruments. |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V3.Market.instruments(
    category = Bitget.API.V3.Market.Instruments.Category.USDT_FUTURES,
)

result = Bitget.API.V3.Market.instruments(
    category = Bitget.API.V3.Market.Instruments.Category.SPOT,
    symbol = "BTCUSDT",
)
```
"""
function instruments(client::BitgetClient, query::InstrumentsQuery)
    return APIsRequest{Data{Vector{InstrumentData}}}("GET", "api/v3/market/instruments", query)(client)
end

function instruments(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return instruments(client, InstrumentsQuery(; kw...))
end

end
