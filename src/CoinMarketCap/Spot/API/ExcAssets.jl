module ExcAssets

export ExcAssetsQuery,
    ExcAssetsData,
    exc_assets


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct ExcAssetsQuery <: CoinMarketCapPublicQuery
    id::String
end

struct Platform 
    crypto_id::Int
    symbol::String
    name::String
end

struct Currency 
    crypto_id::Int
    symbol::String
    name::String
    price_usd::Float64
end

struct DataEntry 
    wallet_address::String
    balance::Float64
    platform::Platform
    currency::Currency
end


struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct ExcAssetsData 
    data::Vector{DataEntry}
    status::Status
end


"""
    exc_assets(client::CoinMarketCapClient, query::ExcAssetsQuery)
    exc_assets(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/exchange/assets`](https://pro-api.coinmarketcap.com/v1/exchange/assets)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| id          | String | true     |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.exc_assets(id="270")

println(to_pretty_json(result.result))
```

## Result:

```{
    ...
  {
      "wallet_address":"0x5a52e96bacdabb82fd05763e25335261b270efcb",
      "balance":1.1617207686e8,
      "platform":{
        "crypto_id":1027,
        "symbol":"ETH",
        "name":"Ethereum"
      },
      "currency":{
        "crypto_id":7224,
        "symbol":"DODO",
        "name":"DODO",
        "price_usd":0.13596747246223914
      }
    }
  ],
  "status":{
    "timestamp":"2024-06-18T23:51:49.733Z",
    "error_code":0,
    "error_message":null,
    "elapsed":42,
    "credit_count":1,
    "notice":null
  }
}
}
```
"""

function exc_assets(client::CoinMarketCapClient, query::ExcAssetsQuery)
    return APIsRequest{ExcAssetsData}("GET", "/v1/exchange/assets", query)(client)
end

function exc_assets(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
   return exc_assets(client, ExcAssetsQuery(; kw...))
end

end