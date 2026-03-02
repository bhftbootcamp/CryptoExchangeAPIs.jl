module QueryInfo

export QueryInfoQuery,
    QueryInfoData,
    query_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bybit
using CryptoExchangeAPIs.Bybit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx ChainStatus begin
    SUSPEND = 0
    NORMAL = 1
end

Base.@kwdef mutable struct QueryInfoQuery <: BybitPrivateQuery
    coin::Maybe{String} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Int64 = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Chain <: BybitData
    chain::String
    chainType::String
    confirmation::Maybe{Int64}
    withdrawFee::Maybe{Float64}
    depositMin::Maybe{Float64}
    withdrawMin::Maybe{Float64}
    minAccuracy::Int64
    chainDeposit::Maybe{ChainStatus.T}
    chainWithdraw::Maybe{ChainStatus.T}
    withdrawPercentageFee::Maybe{Float64}
    contractAddress::Maybe{String}
    safeConfirmNumber::Maybe{Int64}
end

struct CoinInfo <: BybitData
    name::Maybe{String}
    coin::String
    remainAmount::Maybe{Float64}
    chains::Vector{Chain}
end

struct QueryInfoData <: BybitData
    rows::Vector{CoinInfo}
end

function Serde.deser(::Type{Chain}, ::Type{ChainStatus.T}, x::String)
    return ChainStatus.T(parse(Int64, x))
end

function Serde.deser(::Type{Chain}, ::Type{ChainStatus.T}, x::Int64)
    return ChainStatus.T(x)
end

Serde.isempty(::Type{Chain}, x::String) = isempty(x)

"""
    query_info(client::BybitClient, query::QueryInfoQuery)
    query_info(client::BybitClient; kw...)

Query coin information, including chain information, withdraw and deposit status.

[`GET /v5/asset/coin/query-info`](https://bybit-exchange.github.io/docs/v5/asset/coin-info)

## Parameters:

| Parameter | Type   | Required | Description          |
|:----------|:-------|:---------|:---------------------|
| coin      | String | false    | Coin, uppercase only |

## Code samples:

```julia
using CryptoExchangeAPIs.Bybit

client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

result = Bybit.V5.Asset.Coin.query_info(client; coin = "MNT")
```
"""
function query_info(client::BybitClient, query::QueryInfoQuery)
    return APIsRequest{Data{QueryInfoData}}("GET", "v5/asset/coin/query-info", query)(client)
end

function query_info(client::BybitClient; kw...)
    return query_info(client, QueryInfoQuery(; kw...))
end

end

