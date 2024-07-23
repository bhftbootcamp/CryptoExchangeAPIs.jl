module HistoricalTrades

export HistoricalTradesQuery,
    HistoricalTradesData,
    historical_trades

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct HistoricalTradesQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
    fromtId::Maybe{Int64} = nothing
end

struct HistoricalTradesData <: BinanceData
    id::Maybe{Int64}
    price::Maybe{Float64}
    qty::Maybe{Float64}
    quoteQty::Maybe{Float64}
    time::NanoDate
    isBuyerMaker::Bool
end

"""
    historical_trades(client::BinanceClient, query::HistoricalTradesQuery)
    historical_trades(client::BinanceClient = Binance.USDMFutures.public_client; kw...)

[`GET fapi/v1/historicalTrades`](https://binance-docs.github.io/apidocs/futures/en/#old-trades-lookup-market_data)

## Parameters:

| Parameter | Type   | Required | Description                                            |
|:----------|:-------|:---------|:-------------------------------------------------------|
| symbol    | String | true     |                                                        |
| limit     | Int64  | false    | Default: 500; Max: 1000                                |
| fromId    | Int64  | false    | TradeId to fetch from. Default gets most recent trades |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.USDMFutures.historical_trades(;
    symbol = "BTCUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":3697954552,
    "price":66428.01,
    "qty":0.0038,
    "quoteQty":252.426438,
    "time":"2024-07-23T12:50:24.951000064",
    "isBuyerMaker":false
  },
  ...
]
```
"""
function historical_trades(client::BinanceClient, query::HistoricalTradesQuery)
    return APIsRequest{Vector{HistoricalTradesData}}("GET", "/api/v3/historicalTrades", query)(client)
end

function historical_trades(client::BinanceClient = Binance.USDMFutures.public_client; kw...)
    return historical_trades(client, HistoricalTradesQuery(; kw...))
end

end

