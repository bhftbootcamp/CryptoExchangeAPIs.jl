module AvgPrice

export AvgPriceQuery,
    AvgPriceData,
    avg_price

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AvgPriceQuery <: BinancePublicQuery
    symbol::String
end

struct AvgPriceData <: BinanceData
    mins::Maybe{Int64}
    price::Maybe{Float64}
end

"""
    avg_price(client::BinanceClient, query::AvgPriceQuery)
    avg_price(client::BinanceClient = Binance.Spot.public_client; kw...)

Current average price for a symbol.

[`GET api/v3/avgPrice`](https://binance-docs.github.io/apidocs/spot/en/#current-average-price)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.Spot.avg_price(;
    symbol = "ADAUSDT",
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "mins":5,
  "price":0.64545824
}
```
"""
function avg_price(client::BinanceClient, query::AvgPriceQuery)
    return APIsRequest{AvgPriceData}("GET", "api/v3/avgPrice", query)(client)
end

function avg_price(client::BinanceClient = Binance.Spot.public_client; kw...)
    return avg_price(client, AvgPriceQuery(; kw...))
end

end
