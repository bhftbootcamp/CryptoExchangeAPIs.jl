module MarketList

export MarketListQuery,
    MarketListData,
    market_list

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Upbit
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketListQuery <: UpbitPublicQuery
    isDetails::Bool = true
end

struct Caution <: UpbitData 
    PRICE_FLUCTUATIONS::Maybe{Bool}
    TRADING_VOLUME_SOARING::Maybe{Bool}
    DEPOSIT_AMOUNT_SOARING::Maybe{Bool}
    GLOBAL_PRICE_DIFFERENCES::Maybe{Bool}
    CONCENTRATION_OF_SMALL_ACCOUNTS::Maybe{Bool}
end

struct MarketEvent <: UpbitData 
    warning::Maybe{Bool}
    caution::Maybe{Caution}
end

struct MarketListData <: UpbitData
    market::String
    english_name::String
    korean_name::String
    market_event::Maybe{MarketEvent}
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
using CryptoExchangeAPIs.Upbit

result = Upbit.Spot.market_list()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market":"KRW-BTC",
    "english_name":"Bitcoin",
    "korean_name":"비트코인",
    "market_warning":"NONE"
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
