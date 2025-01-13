module CoinInfo

export CoinInfoQuery,
    CoinInfoData,
    coin_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data, List, Rows
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CoinInfoQuery <: BybitPrivateQuery
    coin::Maybe{String} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Maybe{Int64} = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Chain <: BybitData
    chain::String
    chainDeposit::Maybe{Int64}
    chainType::String
    chainWithdraw::Maybe{Int64}
    confirmation::Maybe{Int64}
    depositMin::Maybe{Float64}
    minAccuracy::Int64
    withdrawFee::Maybe{Float64}
    withdrawMin::Maybe{Float64}
    withdrawPercentageFee::Maybe{Float64}
end

struct CoinInfoData <: BybitData
    chains::Vector{Chain}
    coin::String
    name::Maybe{String}
    remainAmount::Maybe{Int64}
end

function Serde.isempty(::Type{<:Chain}, x)::Bool
    return x === ""
end

function Serde.isempty(::Type{<:CoinInfoData}, x)::Bool
    return x === ""
end

"""
    coin_info(client::BybitClient, query::CoinInfoQuery)
    coin_info(client::BybitClient; kw...)

Query Coin Information.

[`GET /v5/asset/coin/query-info`](https://bybit-exchange.github.io/docs/v5/asset/coin-info#http-request)

## Parameters:

| Parameter   | Type     | Required | Description   |
|:------------|:---------|:---------|:--------------|
| coin        | String   | false    |               |
| api_key     | String   | false    |               |
| recv_window | Int64    | false    | Default: 5000 |
| signature   | String   | false    |               |
| timestamp   | DateTime | false    |               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bybit

bybit_client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.Spot.coin_info(bybit_client)

to_pretty_json(result.result)
```

## Result:

```json
{
  "retCode":0,
  "retMsg":"",
  "result":{
    "rows":[
      {
        "chains":[
          {
            "chain":"ETH",
            "chainDeposit":1,
            "chainType":"ERC20",
            "chainWithdraw":1,
            "confirmation":6,
            "depositMin":0.0,
            "minAccuracy":8,
            "withdrawFee":3.0,
            "withdrawMin":3.0,
            "withdrawPercentageFee":0.0 
          }
        ],
        "coin":"AGLD",
        "name":"AGLD",
        "remainAmount":256400
      },
      ...
    ],
    "nextPageCursor":null
  },
  "retExtInfo":{},
  "time":"2024-03-27T14:22:12.088"
}
```
"""
function coin_info(client::BybitClient, query::CoinInfoQuery)
    return APIsRequest{Data{Rows{CoinInfoData}}}("GET", "/v5/asset/coin/query-info", query)(client)
end

function coin_info(client::BybitClient; kw...)
    return coin_info(client, CoinInfoQuery(; kw...))
end

end
