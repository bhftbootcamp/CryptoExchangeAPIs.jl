module CcyInfo

export CcyInfoQuery,
    CcyInfoData,
    ccy_info


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct CcyInfoQuery <: CoinMarketCapPublicQuery
    symbol::String
    skip_invalid::Bool
    aux::String
end

struct Platform begin
    name::String
    coin::Dict{String, Any}
end
end

struct ContractAddress begin
    contract_address::String
    platform::Platform
end
end

struct Urls begin
    website::Vector{String}
    technical_doc::Vector{String}
    explorer::Vector{String}
    source_code::Vector{String}
    message_board::Vector{String}
    chat::Vector{String}
    announcement::Vector{String}
    reddit::Vector{String}
    twitter::Vector{String}
end
end

struct DataEntry begin
    id::Int64
    name::String
    symbol::String
    category::String
    slug::String
    date_launched::String
    urls::Urls
    is_hidden::Int64
    twitter_username::Maybe{String}
    subreddit::Maybe{String}
    tag_names::Maybe{Vector{String}}
    tag_groups::Maybe{Vector{String}}
    contract_address::Vector{ContractAddress}
    self_reported_circulating_supply::Maybe{Float64}
    self_reported_tags::Maybe{Vector{String}}
    self_reported_market_cap::Maybe{Float64}
    infinite_supply::Bool
end
end

struct Status begin
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end
end

struct CcyInfoData begin
    data::Dict{String, Vector{DataEntry}}
    status::Status
end
end

"""
    ccy_info(client::CoinMarketCapClient, query::CcyInfoQuery)
    ccy_info(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v2/cryptocurrency/info`](https://pro-api.coinmarketcap.com/v2/cryptocurrency/info)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| symbol      | String | true     |             |
| skip_invalid| Bool   | true     |             |
| aux         | String | true     |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.ccy_info(symbol="BTC", skip_invalid=true, aux="urls")

println(to_pretty_json(result.result))
```

## Result:

```{
  "data":{
    "BTC":[
      {
        "id":1,
        "name":"Bitcoin",
        "symbol":"BTC",
        "category":"coin",
        "slug":"bitcoin",
        "date_launched":"2010-07-13T00:00:00.000Z",
        "urls":{
          "website":[
            "https://bitcoin.org/"
          ],
          "technical_doc":[
            "https://bitcoin.org/bitcoin.pdf"
          ],
          "explorer":[
            "https://blockchain.info/",
            "https://live.blockcypher.com/btc/",
            "https://blockchair.com/bitcoin",
            "https://explorer.viabtc.com/btc",
            "https://www.okx.com/web3/explorer/btc"
          ],
          "source_code":[
            "https://github.com/bitcoin/bitcoin"
          ],
          "message_board":[
            "https://bitcointalk.org"
          ],
          "chat":[
            
          ],
          "announcement":[
            
          ],
          "reddit":[
            "https://reddit.com/r/bitcoin"
          ],
          "twitter":[
            
          ]
        },
        "is_hidden":0,
        "twitter_username":"",
        "subreddit":"bitcoin",
        "tag_names":null,
        "tag_groups":null,
        "contract_address":[
          
        ],
        "self_reported_circulating_supply":null,
        "self_reported_tags":null,
        "self_reported_market_cap":null,
        "infinite_supply":false
      },
      {
        "id":31652,
        "name":"batcat",
        "symbol":"BTC",
        "category":"token",
        "slug":"batcat",
        "date_launched":"2024-03-27T00:00:00.000Z",
        "urls":{
          "website":[
            "https://www.batcat.lol/"
          ],
          "technical_doc":[
            
          ],
          "explorer":[
            "https://solscan.io/token/EtBc6gkCvsB9c6f5wSbwG8wPjRqXMB5euptK6bqG1R4X"
          ],
          "source_code":[
            
          ],
          "message_board":[
            
          ],
          "chat":[
            "https://t.me/TheBatCatPortal"
          ],
          "announcement":[
            
          ],
          "reddit":[
            
          ],
          "twitter":[
            "https://twitter.com/BatCatonsolana"
          ]
        },
        "is_hidden":0,
        "twitter_username":"BatCatonsolana",
        "subreddit":"",
        "tag_names":null,
        "tag_groups":null,
        "contract_address":[
          {
            "contract_address":"EtBc6gkCvsB9c6f5wSbwG8wPjRqXMB5euptK6bqG1R4X",
            "platform":{
              "name":"Solana",
              "coin":{
                "name":"Solana",
                "id":"5426",
                "symbol":"SOL",
                "slug":"solana"
              }
            }
          }
        ],
        "self_reported_circulating_supply":9.99939377e8,
        "self_reported_tags":null,
        "self_reported_market_cap":160699.68801664165,
        "infinite_supply":false
      },
      {
        "id":31469,
        "name":"Boost Trump Campaign",
        "symbol":"BTC",
        "category":"token",
        "slug":"boost-trump-campaign",
        "date_launched":"2024-05-25T00:00:00.000Z",
        "urls":{
          "website":[
            "https://boosttrumpcampaign.com/"
          ],
          "technical_doc":[
            
          ],
          "explorer":[
            "https://etherscan.io/token/0x300e0d87f8c95d90cfe4b809baa3a6c90e83b850"
          ],
          "source_code":[
            
          ],
          "message_board":[
            
          ],
          "chat":[
            "https://t.me/btctrumpcoin"
          ],
          "announcement":[
            
          ],
          "reddit":[
            
          ],
          "twitter":[
            "https://twitter.com/TrumpBTCoin"
          ]
        },
        "is_hidden":0,
        "twitter_username":"TrumpBTCoin",
        "subreddit":"",
        "tag_names":null,
        "tag_groups":null,
        "contract_address":[
          {
            "contract_address":"0x300e0d87f8c95d90cfe4b809baa3a6c90e83b850",
            "platform":{
              "name":"Ethereum",
              "coin":{
                "name":"Ethereum",
                "id":"1027",
                "symbol":"ETH",
                "slug":"ethereum"
              }
            }
          }
        ],
        "self_reported_circulating_supply":4.2069e11,
        "self_reported_tags":[
          "Political Memes"
        ],
        "self_reported_market_cap":103864.8696427897,
        "infinite_supply":false
      },
      {
        "id":30938,
        "name":"Satoshi Pumpomoto",
        "symbol":"BTC",
        "category":"token",
        "slug":"satoshi-pumpomoto",
        "date_launched":"2024-04-24T00:00:00.000Z",
        "urls":{
          "website":[
            "https://pumpomoto.com/"
          ],
          "technical_doc":[
            
          ],
          "explorer":[
            "https://solscan.io/token/6AGNtEgBE2jph1bWFdyaqsXJ762emaP9RE17kKxEsfiV"
          ],
          "source_code":[
            
          ],
          "message_board":[
            
          ],
          "chat":[
            "https://t.me/pumpomoto"
          ],
          "announcement":[
            
          ],
          "reddit":[
            
          ],
          "twitter":[
            "https://twitter.com/pumpomoto"
          ]
        },
        "is_hidden":0,
        "twitter_username":"pumpomoto",
        "subreddit":"",
        "tag_names":null,
        "tag_groups":null,
        "contract_address":[
          {
            "contract_address":"6AGNtEgBE2jph1bWFdyaqsXJ762emaP9RE17kKxEsfiV",
            "platform":{
              "name":"Solana",
              "coin":{
                "name":"Solana",
                "id":"5426",
                "symbol":"SOL",
                "slug":"solana"
              }
            }
          }
        ],
        "self_reported_circulating_supply":2.1e7,
        "self_reported_tags":[
          "Memes"
        ],
        "self_reported_market_cap":6764.943117634868,
        "infinite_supply":false
      }
    ]
  },
  "status":{
    "timestamp":"2024-06-18T22:15:03.085Z",
    "error_code":0,
    "error_message":null,
    "elapsed":24,
    "credit_count":1,
    "notice":null
  }
}
```
"""

function ccy_info(client::CoinMarketCapClient, query::CcyInfoQuery)
    return APIsRequest{CcyInfoData}("GET", "/v2/cryptocurrency/info", query)(client)
end

function ccy_info(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
    return ccy_info(client, CcyInfoQuery(; kw...))
end

end