module AvgPrice

export AvgPriceQuery,
    AvgPriceData,
    avg_price

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AvgPriceQuery <: MexcPublicQuery
    symbol::String
end

struct AvgPriceData <: MexcData
    mins::Maybe{Int64}
    price::Maybe{Float64}
end

"""
    avg_price(client::MexcClient, query::AvgPriceQuery)
    avg_price(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)

Current average price for a symbol.

[`GET api/v3/avgPrice`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#current-average-price)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.avg_price(;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "mins":5,
  "price":46263.71
}
```
"""
function avg_price(client::MexcClient, query::AvgPriceQuery)
    return APIsRequest{AvgPriceData}("GET", "api/v3/avgPrice", query)(client)
end

function avg_price(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)
    return avg_price(client, AvgPriceQuery(; kw...))
end

end
