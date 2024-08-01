module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: CoinbasePublicQuery
    #__ empty
end

struct TickerData <: CoinbaseData
    ask::Float64
    bid::Float64
    volume::Float64
    trade_id::Maybe{Int64}
    price::Maybe{Float64}
    size::Maybe{Float64}
    time::Maybe{NanoDate}
end

"""
    ticker(client::CoinbaseClient, query::TickerQuery)
    ticker(client::CoinbaseClient = Coinbase.Spot.public_client; kw...)

Gets snapshot information about the last trade (tick), best bid/ask and 24h volume.

[`GET products/{product_id}/ticker`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductticker)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

result = Coinbase.Spot.ticker(
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
function ticker(client::CoinbaseClient, query::TickerQuery; product_id::String)
    return APIsRequest{TickerData}("GET", "products/$product_id/ticker", query)(client)
end

function ticker(client::CoinbaseClient = Coinbase.Spot.public_client; product_id::String, kw...)
    return ticker(client, TickerQuery(; kw...); product_id = product_id)
end

end
