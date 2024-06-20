module PriceConverter

export PriceConverterQuery,
    PriceConverterData,
    price_converter


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct PriceConverterQuery <: CoinMarketCapPublicQuery
    symbol::String
    convert::String
    amount::Maybe{Float64}
end

struct Quote
    price::Float64
    last_updated::String
end

struct DataEntry
    id::Int64
    name::String
    symbol::String
    amount::Float64
    last_updated::String
    quote::Dict{String, Quote}
    end
end

struct Status
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct PriceConverterData <: CoinMarketCapData 
    data::Vector{Any}
    status::Status
end


"""
    price_converter(client::CoinMarketCapClient, query::PriceConverterQuery)
    price_converter(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Convert an amount of one cryptocurrency or fiat currency into one or 
 more different currencies utilizing the latest market rate for each currency.

[`GET /v2/tools/price-conversion`](https://pro-api.coinmarketcap.com/v2/tools/price-conversion)

## Parameters:

| Parameter | Type   | Required | Description |
|:----------|:-------|:---------|:------------|
| symbol    | String | true     |             |
| convert   | String | true     | comma-separated fiat or cryptocurrency symbols to convert the source amount to             |
| amount    | Float64| true     |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CoinMarketCap.Spot.price_converter(;
    symbol = "BTC",
    convert = "USDT",
    amount = 10
) 

to_pretty_json(result.result)
```

## Result:

```json
{
  "data":[
    {
      "amount":2,
      "name":"Bitcoin",
      "quote":{
        "USDT":{
          "price":130486.7646192029,
          "last_updated":"2024-06-20T01:38:00.000Z"
        }
      },
      "id":1,
      "symbol":"BTC",
      "last_updated":"2024-06-20T01:39:00.000Z"
    },
    {
      "amount":2,
      "name":"Boost Trump Campaign",
      "quote":{
        "USDT":{
          "price":8.503266184304235e-7,
          "last_updated":"2024-06-20T01:38:00.000Z"
        }
      },
      "id":31469,
      "symbol":"BTC",
      "last_updated":"2024-06-20T01:38:00.000Z"
    },
    {
      "amount":2,
      "name":"batcat",
      "quote":{
        "USDT":{
          "price":0.00030642219143521717,
          "last_updated":"2024-06-20T01:38:00.000Z"
        }
      },
      "id":31652,
      "symbol":"BTC",
      "last_updated":"2024-06-20T01:38:00.000Z"
    },
    {
      "amount":2,
      "name":"Satoshi Pumpomoto",
      "quote":{
        "USDT":{
          "price":0.0006376037207182016,
          "last_updated":"2024-06-20T01:38:00.000Z"
        }
      },
      "id":30938,
      "symbol":"BTC",
      "last_updated":"2024-06-20T01:39:00.000Z"
    }
  ],
  "status":{
    "timestamp":"2024-06-20T01:40:46.897Z",
    "error_code":0,
    "error_message":null,
    "elapsed":38,
    "credit_count":1,
    "notice":null
  }
}
```
"""
function price_converter(client::CoinMarketCapClient, query::PriceConverterQuery)
    return APIsRequest{PriceConverterData}("GET", "/v2/tools/price-conversion", query)(client)
end

function price_converter(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
    return price_converter(client, PriceConverterQuery(; kw...))
end

end