module Getall

export GetallQuery,
    GetallData,
    getall

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct GetallQuery <: MexcSpotPrivateQuery
    timestamp::Maybe{DateTime} = nothing
    recvWindow::Maybe{Int} = nothing
    signature::Maybe{String} = nothing
end

struct Network <: MexcData
    coin::String
    depositDesc::Maybe{String}
    depositEnable::Bool
    minConfirm::Int
    name::String
    withdrawEnable::Bool
    withdrawFee::Float64
    withdrawIntegerMultiple::Maybe{Float64}
    withdrawMax::Float64
    withdrawMin::Float64
    sameAddress::Bool
    contract::Maybe{String}
    withdrawTips::Maybe{String}
    depositTips::Maybe{String}
    netWork::String
end

struct GetallData <: MexcData
    coin::String
    name::String
    networkList::Vector{Network}
end

"""
    getall(client::MexcSpotClient, query::GetallQuery)
    getall(client::MexcSpotClient; kw...)

Query currency details and the smart contract address.

[`GET api/v3/capital/config/getall`](https://www.mexc.com/api-docs/spot-v3/wallet-endpoints#query-the-currency-information)

## Parameters:

| Parameter  | Type      | Required | Description |
|:-----------|:----------|:---------|:------------|
| timestamp  | DateTime  | false    |             |
| recvWindow | Int       | false    |             |
| signature  | String    | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Mexc

mexc_client = MexcSpotClient(;
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

result = Mexc.API.V3.Capital.Config.getall(mexc_client)
```
"""
function getall(client::MexcSpotClient, query::GetallQuery)
    return APIsRequest{Vector{GetallData}}("GET", "api/v3/capital/config/getall", query)(client)
end

function getall(client::MexcSpotClient; kw...)
    return getall(client, GetallQuery(; kw...))
end

end
