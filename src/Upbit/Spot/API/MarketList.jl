module MarketList

export MarketListQuery,
    MarketListData,
    market_list

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketListQuery <: UpbitPublicQuery
    isDetails::Bool = true
end

struct MarketListData <: UpbitData
    english_name::String
    korean_name::String
    market::String
    market_warning::Maybe{String}
end

"""
    market_list(client::UpbitClient, query::MarketListQuery)
    market_list(client::UpbitClient = Upbit.Spot.public_client; kw...)

Listing Market List

[`GET v1/market/all`](https://docs.upbit.com/reference/마켓-코드-조회)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| isDetails | Bool     | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Upbit

result = Upbit.Spot.market_list(;)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market": "KRW-BTC",
    "korean_name": "비트코인",
    "english_name": "Bitcoin",
    "market_warning": "NONE",
    "market_event": {
      "warning": false,
      "caution": {
        "PRICE_FLUCTUATIONS": false,
        "TRADING_VOLUME_SOARING": false,
        "DEPOSIT_AMOUNT_SOARING": true,
        "GLOBAL_PRICE_DIFFERENCES": false,
        "CONCENTRATION_OF_SMALL_ACCOUNTS": false
      }
    }
  },
  {
    "market": "KRW-ETH",
    "korean_name": "이더리움",
    "english_name": "Ethereum",
    "market_warning": "CAUTION",
    "market_event": {
      "warning": true,
      "caution": {
        "PRICE_FLUCTUATIONS": false,
        "TRADING_VOLUME_SOARING": false,
        "DEPOSIT_AMOUNT_SOARING": false,
        "GLOBAL_PRICE_DIFFERENCES": false,
        "CONCENTRATION_OF_SMALL_ACCOUNTS": false
      }
    }
  },
 ...
] 
```
"""
function market_list(client::UpbitClient, query::MarketListQuery)
    return APIsRequest{Vector{MarketListData}}("GET", "v1/market/all", query)(client)
end

function market_list(client::UpbitClient = Upbit.Spot.public_client; kw...)
    return market_list(client, MarketListQuery(; kw...))
end

end
