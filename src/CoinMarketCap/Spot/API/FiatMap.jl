module FiatMap

export FiatMapQuery,
    FiatMapData,
    fiat_map


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct FiatMapQuery <: CoinMarketCapPublicQuery
    start::Int64
    limit::Int64
    sort::String
    include_metals::Bool
end

struct DataEntry 
    id::Int64
    name::String
    sign::String
    symbol::String
end

struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct FiatMapData <: CoinMarketCapData 
    data::Vector{Any}
    status::Status
end

"""
    fiat_map(client::CoinMarketCapClient, query::FiatMapQuery)
    fiat_map(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/fiat/map`](https://pro-api.coinmarketcap.com/v1/fiat/map)

## Parameters:

| Parameter      | Type   | Required  | Description  |
|:---------------|:-------|:--------- |:------------|
| start          | Int64  | true      |             |
| limit          | Int64  | true      |             |
| sort           | String | true      |             |
| include_metals | Bool   | true      |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.fiat_map(start=1, limit=10, sort="id", include_metals=true)

println(to_pretty_json(result.result))
```

## Result:

```{
    "data": [
        {
            "name": "United States Dollar",
            "sign": "\$",
            "id": 2781,
            "symbol": "USD"
        },
        {
            "name": "Australian Dollar",
            "sign": "\$",
            "id": 2782,
            "symbol": "AUD"
        },
        {
            "name": "Brazilian Real",
            "sign": "R\$",
            "id": 2783,
            "symbol": "BRL"
        },
        {
            "name": "Canadian Dollar",
            "sign": "\$",
            "id": 2784,
            "symbol": "CAD"
        },
        {
            "name": "Swiss Franc",
            "sign": "Fr",
            "id": 2785,
            "symbol": "CHF"
        },
        {
            "name": "Chilean Peso",
            "sign": "\$",
            "id": 2786,
            "symbol": "CLP"
        },
        {
            "name": "Chinese Yuan",
            "sign": "¥",
            "id": 2787,
            "symbol": "CNY"
        },
        {
            "name": "Czech Koruna",
            "sign": "Kč",
            "id": 2788,
            "symbol": "CZK"
        },
        {
            "name": "Danish Krone",
            "sign": "kr",
            "id": 2789,
            "symbol": "DKK"
        },
        {
            "name": "Euro",
            "sign": "€",
            "id": 2790,
            "symbol": "EUR"
        }
    ],
    "status": {
        "timestamp": "2024-06-18T22:11:24.270Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 71,
        "credit_count": 1,
        "notice": null
    }
}
```
"""

function fiat_map(client::CoinMarketCapClient, query::FiatMapQuery)
    return APIsRequest{FiatMapData}("GET", "/v1/fiat/map", query)(client)
end

function fiat_map(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
    return fiat_map(client, FiatMapQuery(; kw...))
end

end