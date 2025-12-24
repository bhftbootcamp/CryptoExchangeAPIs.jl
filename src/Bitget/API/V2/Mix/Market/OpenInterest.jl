module OpenInterest

export OpenInterestQuery,
    OpenInterestData,
    open_interest

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

Base.@kwdef struct OpenInterestQuery <: BitgetPublicQuery
    productType::SettleType.T
    symbol::String
end

function Serde.SerQuery.ser_type(::Type{OpenInterestQuery}, x::SettleType.T)
    x == SettleType.USDT_FUTURES && return "USDT-FUTURES"
    x == SettleType.USDC_FUTURES && return "USDC-FUTURES"
    x == SettleType.COIN_FUTURES && return "COIN-FUTURES"
end

struct OpenInterestEntry <: BitgetData
    symbol::String
    size::Float64
end

struct OpenInterestData <: BitgetData
    openInterestList::Vector{OpenInterestEntry}
    ts::NanoDate
end

"""
    open_interest(client::BitgetClient, query::OpenInterestQuery)
    open_interest(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get the total positions of a certain trading pair on the platform.

[`GET api/v2/mix/market/open-interest`](https://www.bitget.com/api-doc/contract/market/Get-Open-Interest)

## Parameters:

| Parameter   | Type       | Required | Description                                  |
|:------------|:-----------|:---------|:---------------------------------------------|
| productType | SettleType | true     | USDT\\_FUTURES USDC\\_FUTURES COIN\\_FUTURES |
| symbol      | String     | true     |                                              |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V2.Mix.Market.open_interest(
    productType = Bitget.API.V2.Mix.Market.OpenInterest.SettleType.USDT_FUTURES,
    symbol = "BTCUSDT",
)
```
"""
function open_interest(client::BitgetClient, query::OpenInterestQuery)
    return APIsRequest{Data{OpenInterestData}}("GET", "api/v2/mix/market/open-interest", query)(client)
end

function open_interest(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return open_interest(client, OpenInterestQuery(; kw...))
end

end
