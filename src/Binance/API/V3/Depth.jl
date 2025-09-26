module Depth

export DepthQuery,
    DepthData,
    depth

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct DepthQuery <: BinancePublicQuery
    symbol::String
    limit::Maybe{Int64} = nothing
end

struct Level <: BinanceData
    price::Float64
    size::Float64
end

struct DepthData <: BinanceData
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
end

"""
    depth(client::BinanceClient, query::DepthQuery)
    depth(client::BinanceClient = Binance.BinanceClient(Binance.public_config); kw...)

[`GET api/v3/depth`](https://binance-docs.github.io/apidocs/spot/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.API.V3.depth(;
    symbol = "ADAUSDT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "asks":[
    {
      "price":0.634,
      "size":1478.6
    },
    ...
  ],
  "bids":[
    {
      "price":0.6339,
      "size":28448.6
    },
    ...
  ],
  "lastUpdateId":8394873195
}
```
"""
function depth(client::BinanceClient, query::DepthQuery)
    return APIsRequest{DepthData}("GET", "api/v3/depth", query)(client)
end

function depth(
    client::BinanceClient = Binance.BinanceClient(Binance.public_config);
    kw...,
)
    return depth(client, DepthQuery(; kw...))
end

end
