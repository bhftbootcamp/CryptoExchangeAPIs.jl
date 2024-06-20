module CoinCategories

export CoinCategoriesQuery,
    CoinCategoriesData,
   coin_categories


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct CoinCategoriesQuery <: CoinMarketCapPublicQuery
    start::Int64
    limit::Int64
    slug::String
    symbol::String
end

struct DataEntry
    id::Int64
    name::String
    title::String
    description::String
    num_tokens::Int64
    avg_price_change::Float64
    market_cap::Float64
    market_cap_change::Float64
    volume::Float64
    volume_change::Float64
    last_updated::DateTime
end

struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct CoinCategoriesData 
    data::Vector{Any}
    status::Status
end


"""
   coin_categories(client::CoinMarketCapClient, query::CoinCategoriesQuery)
   coin_categories(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/cryptocurrency/categories`](https://pro-api.coinmarketcap.com/v1/cryptocurrency/categories)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| Start       | Int64  | true     |             |
| limit       | Int64  | true     |             |
| slug        | String | true     |             |
| symbol      | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.coin_categories(start=1,limit=2,slug="bitcoin",symbol="BTC")

println(to_pretty_json(result.result))
```

## Result:

```{
    "data":[
    {
      "market_cap_change":-2.3433360000000003,
      "name":"FTX Bankruptcy Estate ",
      "volume_change":46.29639599999999,
      "id":"6437284985f6a3507d5fd57d",
      "description":"FTX Bankruptcy Estate ",
      "num_tokens":27,
      "last_updated":"2023-09-09T20:39:55.222Z",
      "avg_price_change":-4.0956373916,
      "market_cap":1.8505740932273804e12,
      "volume":6.94585345288257e10,
      "title":"FTX Bankruptcy Estate "
    },
    {
      "market_cap_change":-3.661070129870129,
      "name":"Bitcoin Ecosystem",
      "volume_change":32.501428571428576,
      "id":"63feda8ad0a19758f3bde124",
      "description":"Bitcoin Ecosystem",
      "num_tokens":94,
      "last_updated":"2023-08-09T13:53:10.756Z",
      "avg_price_change":-5.875852966623376,
      "market_cap":1.3115099937606006e12,
      "volume":4.1312510567667915e10,
      "title":"Bitcoin Ecosystem"
    }
  ],
  "status":{
    "timestamp":"2024-06-19T00:23:47.021Z",
    "error_code":0,
    "error_message":null,
    "elapsed":353,
    "credit_count":1,
    "notice":null
  }
  }
}
```
"""

function coin_categories(client::CoinMarketCapClient, query::CoinCategoriesQuery)
    return APIsRequest{CoinCategoriesData}("GET", "/v1/cryptocurrency/categories", query)(client)
end

function coin_categories(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
   return coin_categories(client, CoinCategoriesQuery(; kw...))
end

end