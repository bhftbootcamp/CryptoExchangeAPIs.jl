module AccountTrade

export AccountTradeQuery,
    AccountTradeData,
    account_trade

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct AccountTradeQuery <: BinancePrivateQuery
    symbol::String
    orderId::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    fromId::Maybe{Int64} = nothing
    limit::Maybe{Int64} = 1000

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct AccountTradeData <: BinanceData
    symbol::String
    id::Int64
    orderId::Int64
    orderListId::Int64
    price::Float64
    qty::Float64
    quoteQty::Float64
    commission::Float64
    commissionAsset::String
    time::NanoDate
    isBuyer::Bool
    isMaker::Bool
    isBestMatch::Bool
end

"""
    account_trade(client::BinanceClient, query::AccountTradeQuery)
    account_trade(client::BinanceClient; kw...)

Get trades for a specific account and symbol.

[`GET api/v3/myTrades`](https://binance-docs.github.io/apidocs/spot/en/#account-trade-list-user_data)

## Parameters:

| Parameter  | Type     | Required | Description   |
|:-----------|:---------|:---------|:--------------|
| symbol     | String   | true     |               |
| orderId    | Int64    | false    |               |
| startTime  | DateTime | false    |               |
| endTime    | DateTime | false    |               |
| fromId     | Int64    | false    |               |
| limit      | Int64    | false    | Default: 1000 |
| recvWindow | Int64    | false    |               |
| signature  | String   | false    |               |
| timestamp  | DateTime | false    |               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.Spot.account_trade(
    binance_client;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BNBBTC",
    "id":28457,
    "orderId":100234,
    "orderListId":-1,
    "price":4.00000100,
    "qty":12.00000000,
    "quoteQty":48.000012,
    "commission":10.10000000,
    "commissionAsset":"BNB",
    "time":"2017-07-12T13:19:09",
    "isBuyer":true,
    "isMaker":false,
    "isBestMatch":true
  },
  ...
]
```
"""
function account_trade(client::BinanceClient, query::AccountTradeQuery)
    return APIsRequest{Vector{AccountTradeData}}("GET", "api/v3/myTrades", query)(client)
end

function account_trade(client::BinanceClient; kw...)
    return account_trade(client, AccountTradeQuery(; kw...))
end

end
