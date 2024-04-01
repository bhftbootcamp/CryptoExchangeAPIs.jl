module PremiumIndex

export PremiumIndexQuery,
    PremiumIndexData,
    premium_index

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct PremiumIndexQuery <: BinancePublicQuery
    symbol::Maybe{String} = nothing
    pair::Maybe{String} = nothing
end

struct PremiumIndexData <: BinanceData
    symbol::String
    pair::String
    markPrice::Maybe{Float64}
    indexPrice::Maybe{Float64}
    estimatedSettlePrice::Maybe{Float64}
    lastFundingRate::Maybe{String}
    interestRate::Maybe{String}
    nextFundingTime::NanoDate
    time::NanoDate
end

"""
    premium_index(client::BinanceClient, query::PremiumIndexQuery)
    premium_index(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)

[`GET dapi/v1/premiumIndex`](https://binance-docs.github.io/apidocs/delivery/en/#index-price-and-mark-price)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| symbol    | String   | false    |             |
| pair      | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.CoinMFutures.premium_index(;
    pair = "BTCUSD",
)

to_pretty_json(result.result)
```

## Result:

```json
[
 {
    "symbol":"BTCUSD_240329",
    "pair":"BTCUSD",
    "markPrice":70397.85306869,
    "indexPrice":70195.20240214,
    "estimatedSettlePrice":70128.01636024,
    "lastFundingRate":"",
    "interestRate":"",
    "nextFundingTime":"1970-01-01T00:00:00",
    "time":"2024-03-26T18:22:48"
  },
  ...
]
```
"""
function premium_index(client::BinanceClient, query::PremiumIndexQuery)
    return APIsRequest{Vector{PremiumIndexData}}("GET", "dapi/v1/premiumIndex", query)(client)
end

function premium_index(client::BinanceClient = Binance.CoinMFutures.public_client; kw...)
    return premium_index(client, PremiumIndexQuery(; kw...))
end

end
