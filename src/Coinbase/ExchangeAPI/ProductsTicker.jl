module ProductsTicker

export ProductsTickerQuery,
    ProductsTickerData,
    products_ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ProductsTickerQuery <: CoinbasePublicQuery
    product_id::String
end

Serde.SerQuery.ser_ignore_field(::Type{ProductsTickerQuery}, ::Val{:product_id}) = true

struct ProductsTickerData <: CoinbaseData
    ask::Float64
    bid::Float64
    volume::Float64
    trade_id::Maybe{Int64}
    price::Maybe{Float64}
    size::Maybe{Float64}
    time::Maybe{NanoDate}
end

"""
    products_ticker(client::CoinbaseClient, query::ProductsTickerQuery)
    products_ticker(client::CoinbaseClient = Coinbase.ExchangeAPI.public_client; kw...)

Gets snapshot information about the last trade (tick), best bid/ask and 24h volume.

[`GET products/{product_id}/ticker`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductticker)

## Parameters:

| Parameter  | Type     | Required | Description |
|:-----------|:---------|:---------|:------------|
| product_id | String   | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

result = Coinbase.ExchangeAPI.products_ticker(
    product_id = "ADA-USDT",
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "ask":0.633,
  "bid":0.632,
  "volume":420912.11,
  "trade_id":679787,
  "price":0.633,
  "size":23.7,
  "time":"2024-03-21T23:34:52.062646"
}
```
"""
function products_ticker(client::CoinbaseClient, query::ProductsTickerQuery;)
    return APIsRequest{ProductsTickerData}("GET", "products/$(query.product_id)/ticker", query)(client)
end

function products_ticker(client::CoinbaseClient = Coinbase.ExchangeAPI.public_client; kw...)
    return products_ticker(client, ProductsTickerQuery(; kw...))
end

end
