module History

export FundingHistoryQuery, history

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Category linear inverse

Base.@kwdef struct FundingHistoryQuery <: BybitPublicQuery
    category::Category.T
    symbol::String
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int} = nothing
end

struct FundingRateEntry <: BybitData
    symbol::String
    fundingRate::Float64
    fundingRateTimestamp::NanoDate
end

"""
    history(client::BybitClient, query::FundingHistoryQuery)
    history(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)

Query for historical funding rates. Each symbol has a different funding interval.
To query the funding rate interval, use the instruments-info endpoint.

Covers: USDT and USDC perpetual / Inverse perpetual.

[`GET /v5/market/funding/history`](https://bybit-exchange.github.io/docs/v5/market/history-fund-rate)

## Parameters:

| Parameter  | Type    | Required | Description                                          |
|:-----------|:--------|:---------|:-----------------------------------------------------|
| category   | Category| true     | Product type: linear, inverse.                       |
| symbol     | String  | true     | Symbol name (e.g. BTCUSDT, ETHPERP), uppercase.      |
| startTime  | Int     | false    | Start timestamp (ms). Passing only startTime errors. |
| endTime    | Int     | false    | End timestamp (ms). Only endTime returns 200 records.|
| limit      | Int     | false    | Limit per page [1, 200]. Default 200.                |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

result = Bybit.V5.Market.Funding.History.history(;
    category = Bybit.V5.Market.Funding.History.Category.linear,
    symbol = "ETHPERP",
    limit = 10,
)
```
"""
function history(client::BybitClient, query::FundingHistoryQuery)
    return APIsRequest{Data{List{FundingRateEntry}}}("GET", "v5/market/funding/history", query)(client)
end

function history(client::BybitClient = Bybit.BybitClient(Bybit.public_config); kw...)
    return history(client, FundingHistoryQuery(; kw...))
end

end
