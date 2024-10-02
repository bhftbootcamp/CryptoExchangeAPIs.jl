module Market

export MarketQuery,
    MarketData,
    market

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct MarketQuery <: BithumbPublicQuery
    isDetails::Bool = false
end

struct MarketData <: BithumbData
    market::String
    korean_name::String
    english_name::String
end

"""
    market(client::BithumbClient, query::MarketQuery)
    market(client::BithumbClient = Bithumb.Spot.public_client; kw...)

List of markets available for trading on Bithumb.

[`GET v1/market/all`](https://apidocs.bithumb.com/reference/)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| isDetails | Bool   | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bithumb

result = Bithumb.Spot.market()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "market":"KRW-BTC",
    "korean_name":"비트코인",
    "english_name":"Bitcoin"
  },
  {
    "market":"KRW-ETH",
    "korean_name":"이더리움",
    "english_name":"Ethereum"
  },
  ...
]
```
"""
function market(client::BithumbClient, query::MarketQuery; kw...)
    return APIsRequest{Vector{MarketData}}("GET", "v1/market/all", query)(client)
end

function market(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return market(client, MarketQuery(; kw...))
end

end
