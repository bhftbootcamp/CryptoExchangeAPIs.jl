module AccountTrade

export AccountTradeQuery,
    AccountTradeData,
    account_trade

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct AccountTradeQuery <: MexcSpotPrivateQuery
    symbol::String
    orderId::Maybe{String} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct AccountTradeData <: MexcData
    symbol::String
    id::String
    orderId::String
    orderListId::Maybe{Int64}
    price::Maybe{String}
    qty::Maybe{String}
    quoteQty::Maybe{String}
    commission::Maybe{String}
    commissionAsset::Maybe{String}
    time::Maybe{NanoDate}
    isBuyer::Maybe{Bool}
    isMaker::Maybe{Bool}
    isBestMatch::Maybe{Bool}
    isSelfTrade::Maybe{Bool}
    clientOrderId::Maybe{String}
end

"""
    account_trade(client::MexcClient, query::AccountTradeQuery)
    account_trade(client::MexcClient; kw...)

Get trades for a specific account and symbol.

[`GET api/v3/myTrades`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#account-trade-list)

## Parameters:

| Parameter  | Type     | Required | Description   |
|:-----------|:---------|:---------|:--------------|
| symbol     | String   | true     |               |
| orderId    | String   | false    |               |
| startTime  | DateTime | false    |               |
| endTime    | DateTime | false    |               |
| limit      | Int64    | false    | Default 100   |
| recvWindow | Int64    | false    |               |
| timestamp  | DateTime | false    |               |
| signature  | String   | false    |               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

mexc_client = MexcClient(;
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

result = Mexc.API.V3.account_trade(
    mexc_client;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"BTCUSDT",
    "id":"fad2af9e942049b6adbda1a271f990c6",
    "orderId":"bb41e5663e124046bd9497a3f5692f39",
    "orderListId":-1,
    "price":"46000.10",
    "qty":"0.001",
    "quoteQty":"46.00",
    "commission":"0.00001",
    "commissionAsset":"BTC",
    "time":"2024-01-05T09:25:00",
    "isBuyer":true,
    "isMaker":false,
    "isBestMatch":true,
    "isSelfTrade":false,
    "clientOrderId":null
  },
  ...
]
```
"""
function account_trade(client::MexcClient, query::AccountTradeQuery)
    return APIsRequest{Vector{AccountTradeData}}("GET", "api/v3/myTrades", query)(client)
end

function account_trade(client::MexcClient; kw...)
    return account_trade(client, AccountTradeQuery(; kw...))
end

end
