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
    E::NanoDate             # Message output time
    T::NanoDate             # Transaction time
    asks::Vector{Level}
    bids::Vector{Level}
    lastUpdateId::Int64
end

"""
    depth(client::BinanceClient, query::DepthQuery)
    depth(client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config); kw...)

[`GET fapi/v1/depth`](https://binance-docs.github.io/apidocs/futures/en/#order-book)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| limit     | Int64  | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.FAPI.V1.depth(;
    symbol = "ADAUSDT"
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "T":"2024-03-21T21:25:53.671000064",
  "E":"2024-03-21T21:25:53.680999936",
  "asks":[
    {
      "price":0.6337,
      "size":20325.0
    },
    ...
  ],
  "lastUpdateId":4248628084740,
  "bids":[
    {
      "price":0.6336,
      "size":58607.0
    },
    ...
  ]
}
```
"""
function depth(client::BinanceClient, query::DepthQuery)
    return APIsRequest{DepthData}("GET", "fapi/v1/depth", query)(client)
end

function depth(
    client::BinanceClient = Binance.BinanceClient(Binance.public_fapi_config);
    kw...,
)
    return depth(client, DepthQuery(; kw...))
end

end
