module HistoryFundRate

export HistoryFundRateQuery,
    HistoryFundRateEntry,
    history_fund_rate

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

Base.@kwdef struct HistoryFundRateQuery <: BitgetPublicQuery
    symbol::String
    productType::SettleType.T
    pageSize::Maybe{Int} = nothing
    pageNo::Maybe{Int} = nothing
end

function Serde.SerQuery.ser_type(::Type{HistoryFundRateQuery}, x::SettleType.T)
    x == SettleType.USDT_FUTURES && return "USDT-FUTURES"
    x == SettleType.USDC_FUTURES && return "USDC-FUTURES"
    x == SettleType.COIN_FUTURES && return "COIN-FUTURES"
end

struct HistoryFundRateEntry <: BitgetData
    symbol::String
    fundingRate::Float64
    fundingTime::NanoDate
end

"""
    history_fund_rate(client::BitgetClient, query::HistoryFundRateQuery)
    history_fund_rate(client::BitgetClient = Bitget.BitgetClient(Bitget.public_config); kw...)

Get the historical funding rate of the contract.

[`GET api/v2/mix/market/history-fund-rate`](https://www.bitget.com/api-doc/contract/market/Get-History-Funding-Rate)

## Parameters:

| Parameter   | Type       | Required | Description                                                                 |
|:------------|:-----------|:---------|:----------------------------------------------------------------------------|
| symbol      | String     | true     | Trading pair (e.g. `\"BTCUSDT\"`).                                          |
| productType | SettleType | true     | USDT\\_FUTURES USDC\\_FUTURES COIN\\_FUTURES                                |
| pageSize    | Int        | false    | Number of results per page; default 20, maximum 100.                        |
| pageNo      | Int        | false    | Page number.                                                                |

## Code samples:

```julia
using CryptoExchangeAPIs.Bitget

result = Bitget.API.V2.Mix.Market.history_fund_rate(
    symbol = "BTCUSDT",
    productType = Bitget.API.V2.Mix.Market.HistoryFundRate.SettleType.USDT_FUTURES,
)
```
"""
function history_fund_rate(client::BitgetClient, query::HistoryFundRateQuery)
    return APIsRequest{Data{Vector{HistoryFundRateEntry}}}(
        "GET", "api/v2/mix/market/history-fund-rate", query
    )(client)
end

function history_fund_rate(
    client::BitgetClient = Bitget.BitgetClient(Bitget.public_config);
    kw...,
)
    return history_fund_rate(client, HistoryFundRateQuery(; kw...))
end

end
