module IDMap

export IDMapQuery,
    IDMapData,
    id_map


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct IDMapQuery <: CoinMarketCapPublicQuery
    listing_status::String
    start::Int64
    limit::Int64
    sort::String
    symbol::String
    aux::String
end

struct Platform 
    id::Int64
    name::String
    symbol::String
    slug::String
    token_address::String
end

struct DataEntry 
    id::Int64
    rank::Float64
    name::String
    symbol::String
    slug::String
    is_active::Int64
    status::String
    first_historical_data::String
    last_historical_data::String
    platform::Dict{String, Platform}
end

struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct IDMapData <: CoinMarketCapData 
    data::Vector{Any}
    status::Status
end

"""
    id_map(client::CoinMarketCapClient, query::IDMapQuery)
    id_map(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/cryptocurrency/map`](https://pro-api.coinmarketcap.com/v1/cryptocurrency/map)

## Parameters:

| Parameter     | Type   | Required | Description |
|:--------------|:-------|:---------|:------------|
| listing_status| String | true     |             |
| start         | Int64  | true     |             |
| limit         | Int64  | true     |             |
| sort          | String | true     |             |
| symbol        | String | true     |             |
| aux           | String | true     |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.id_map(
            listing_status="active", 
            start=1, 
            limit=10, 
            sort="id", 
            symbol="BTC",
            aux="platform"
        )
        

println(to_pretty_json(result.result))
```

## Result:

```println(data_json)
{
    "data": [
        {
            "rank": 1,
            "name": "Bitcoin",
            "platform": null,
            "id": 1,
            "symbol": "BTC",
            "slug": "bitcoin"
        },
        {
            "rank": 4567,
            "name": "batcat",
            "platform": {
                "name": "Solana",
                "id": 16,
                "symbol": "SOL",
                "slug": "solana",
                "token_address": "EtBc6gkCvsB9c6f5wSbwG8wPjRqXMB5euptK6bqG1R4X"
            },
            "id": 31652,
            "symbol": "BTC",
            "slug": "batcat"
        },
        {
            "rank": 5619,
            "name": "Boost Trump Campaign",
            "platform": {
                "name": "Ethereum",
                "id": 1,
                "symbol": "ETH",
                "slug": "ethereum",
                "token_address": "0x300e0d87f8c95d90cfe4b809baa3a6c90e83b850"
            },
            "id": 31469,
            "symbol": "BTC",
            "slug": "boost-trump-campaign"
        },
        {
            "rank": 6358,
            "name": "Satoshi Pumpomoto",
            "platform": {
                "name": "Solana",
                "id": 16,
                "symbol": "SOL",
                "slug": "solana",
                "token_address": "6AGNtEgBE2jph1bWFdyaqsXJ762emaP9RE17kKxEsfiV"
            },
            "id": 30938,
            "symbol": "BTC",
            "slug": "satoshi-pumpomoto"
        }
    ],
    "status": {
        "timestamp": "2024-06-18T22:07:13.384Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 13,
        "credit_count": 1,
        "notice": null
    }
}
```
"""

function id_map(client::CoinMarketCapClient, query::IDMapQuery)
    return APIsRequest{IDMapData}("GET", "/v1/cryptocurrency/map", query)(client)
end

function id_map(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
    return id_map(client, IDMapQuery(; kw...))
end

end