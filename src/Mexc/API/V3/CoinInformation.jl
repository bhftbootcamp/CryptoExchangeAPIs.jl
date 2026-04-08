module CoinInformation

export CoinInformationQuery,
    CoinInformationData,
    coin_information

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CoinInformationQuery <: MexcSpotPrivateQuery
    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct Networklist <: MexcData
    coin::Maybe{String}
    depositDesc::Maybe{String}
    depositEnable::Maybe{Bool}
    minConfirm::Maybe{Int64}
    Name::Maybe{String}
    network::Maybe{String}
    withdrawEnable::Maybe{Bool}
    withdrawFee::Maybe{String}
    withdrawIntegerMultiple::Maybe{String}
    withdrawMax::Maybe{String}
    withdrawMin::Maybe{String}
    sameAddress::Maybe{Bool}
    contract::Maybe{String}
    withdrawTips::Maybe{String}
    depositTips::Maybe{String}
    netWork::Maybe{String}
end

struct CoinInformationData <: MexcData
    coin::String
    Name::Maybe{String}
    networkList::Maybe{Vector{Networklist}}
end

"""
    coin_information(client::MexcClient, query::CoinInformationQuery)
    coin_information(client::MexcClient; kw...)

Query currency details and the smart contract address.

[`GET api/v3/capital/config/getall`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#query-the-currency-information)

## Parameters:

| Parameter  | Type     | Required | Description |
|:-----------|:---------|:---------|:------------|
| recvWindow | Int64    | false    |             |
| timestamp  | DateTime | false    |             |
| signature  | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

mexc_client = MexcClient(;
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

result = Mexc.API.V3.coin_information(mexc_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "coin":"EOS",
    "Name":"EOS",
    "networkList":[
      {
        "coin":"EOS",
        "depositDesc":null,
        "depositEnable":true,
        "minConfirm":0,
        "Name":"EOS",
        "network":"EOS",
        "withdrawEnable":false,
        "withdrawFee":"0.0001",
        "withdrawIntegerMultiple":null,
        "withdrawMax":"10000",
        "withdrawMin":"0.001",
        "sameAddress":false,
        "contract":"TN3W4H6rK2ce4vX9YnFQHwKENnHjoxbm9",
        "withdrawTips":"Both a MEMO and an Address are required.",
        "depositTips":"Both a MEMO and an Address are required.",
        "netWork":"EOS"
      }
    ]
  },
  ...
]
```
"""
function coin_information(client::MexcClient, query::CoinInformationQuery)
    return APIsRequest{Vector{CoinInformationData}}("GET", "api/v3/capital/config/getall", query)(client)
end

function coin_information(client::MexcClient; kw...)
    return coin_information(client, CoinInformationQuery(; kw...))
end

end
