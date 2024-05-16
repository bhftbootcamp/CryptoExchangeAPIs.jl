module PrivateFundingHistory

export PrivateFundingHistoryQuery,
    PrivateFundingHistoryData,
    private_funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kucoin
using CryptoAPIs.Kucoin: Data, Page
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct PrivateFundingHistoryQuery <: KucoinPrivateQuery
    symbol::String
    startAt::Maybe{NanoDate}
    endAt::Maybe{NanoDate}
    reverse::Maybe{Bool}
    offset::Maybe{Int64}
    forward::Maybe{Bool}
    maxCount::Maybe{Int64}

    passphrase::Maybe{String} = nothing
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct Datalist <: KucoinData
    id::Int64
    symbol::String
    timePoint::NanoDate
    fundingRate::Float64
    markPrice::Float64
    positionQty::Int64
    positionCost::Float64
    funding::Float64
    settleCurrency::String
end

function Serde.isempty(::Type{Datalist}, x)::Bool
    return x === ""
end

struct PrivateFundingHistoryData <: KucoinData
    dataList::Vector{Datalist}
    hasMore::Bool
end

"""
    private_funding_history(client::KucoinClient, query::PrivateFundingHistoryQuery)
    private_funding_history(client::KucoinClient; kw...)

Submit request to get the funding history.

[`GET api/v1/funding-history`](https://www.kucoin.com/docs/rest/futures-trading/funding-fees/get-private-funding-history#api-key-permissions)

## Parameters:

| Parameter  | Type     | Required | Description                  |
|:---------- |:---------|:---------|:-----------------------------|
| symbol     | String   | true     |                              |
| startAt    | NanoDate | false    |                              |
| endAt      | NanoDate | false    |                              |
| reverse    | Bool     | false    |                              |
| offset     | Int64    | false    |                              |
| forward    | Bool     | false    |                              |
| maxCount   | Int64    | false    |                              |
| passphrase | String   | false    |                              |
| signature  | String   | false    |                              |
| timestamp  | DateTime | false    |                              |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kucoin

kucoin_client = KucoinClient(;
    base_url = "https://api-futures.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

result = Kucoin.Futures.private_funding_history(
    kucoin_client;
    symbol = "XBTUSDM",
)

to_pretty_json(result.result)
```

## Result:

"""
function private_funding_history(client::KucoinClient, query::PrivateFundingHistoryQuery)
    return APIsRequest{Vector{PrivateFundingHistoryData}}("GET", "api/v1/funding-history", query)(client)
end

function private_funding_history(client::KucoinClient; kw...)
    return private_funding_history(client, PrivateFundingHistoryQuery(; kw...))
end

end
