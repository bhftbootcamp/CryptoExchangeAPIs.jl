module ExcInfo

export ExcInfoQuery,
    ExcInfoData,
    exc_info


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct ExcInfoQuery <: CoinMarketCapPublicQuery
    slug::String
    aux::String
end

struct URLs
    website::Vector{String}
    blog::Vector{String}
    chat::Vector{String}
    fee::Vector{String}
    twitter::Vector{String}
end

struct DataEntry
    id::Int
    name::String
    slug::String
    logo::Union{String, Nothing}
    description::Union{String, Nothing}
    date_launched::Union{Date, Nothing}
    notice::Union{String, Nothing}
    weekly_visits::Union{Float64, Nothing}
    spot_volume_usd::Union{Float64, Nothing}
    urls::URLs
end


struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end


struct ExcInfoData 
    data::Dict{String, Any}
    status::Status
end



"""
    exc_info(client::CoinMarketCapClient, query::ExcInfoQuery)
    exc_info(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/exchange/info`](https://pro-api.coinmarketcap.com/v1/exchange/info)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| slug        | String | true     |             |
| aux         | String | true     |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.exc_info(slug="binance", aux="urls")

println(to_pretty_json(result.result))
```

## Result:

```{
  "data":{
    "binance":{
      "is_hidden":0,
      "taker_fee":0.04,
      "spot_volume_last_updated":"2024-06-18T22:55:17.524Z",
      "maker_fee":0.02,
      "spot_volume_usd":2.27908016813832e10,
      "porAuditStatus":0,
      "name":"Binance",
      "id":270,
      "urls":{
        "fee":[
          "https://www.binance.com/en/fee/schedule"
        ],
        "blog":[
          
        ],
        "website":[
          "https://www.binance.com/"
        ],
        "twitter":[
          "https://twitter.com/binance"
        ],
        "actual":[
          
        ],
        "chat":[
          "https://t.me/binanceexchange"
        ]
      },
      "walletSourceStatus":0,
      "slug":"binance",
      "is_redistributable":1,
      "porSwitch":"{\"totalAssetSwitch\":1,\"auditSwitch\":0,\"walletAddressSwitch\":1,\"tokenSwitch\":1}",
      "weekly_visits":14099260,
      "countries":[
        
      ],
      "porStatus":1,
      "fiats":[
        "EUR",
        " GBP",
        " BRL",
        " AUD",
        " UAH",
        " RUB",
        " TRY",
        " ZAR",
        " PLN",
        " NGN",
        " RON"
      ],
      "tags":null,
      "type":""
    }
  },
  "status":{
    "timestamp":"2024-06-18T22:58:01.147Z",
    "error_code":0,
    "error_message":null,
    "elapsed":12,
    "credit_count":1,
    "notice":null
  }
}
```
"""

function exc_info(client::CoinMarketCapClient, query::ExcInfoQuery)
    return APIsRequest{ExcInfoData}("GET", "/v1/exchange/info", query)(client)
end

function exc_info(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
    return exc_info(client, ExcInfoQuery(; kw...))
end

end