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

struct DataList <: KucoinData
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

function Serde.isempty(::Type{DataList}, x)::Bool
    return x === ""
end

struct PrivateFundingHistoryData <: KucoinData
    dataList::Vector{DataList}
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

```json
{
  "dataList": [
    {
      "id": 36275152660006,
      "symbol": "XBTUSDM",
      "timePoint": "2019-05-15T11:00:00",
      "fundingRate": 13e-5,
      "markPrice": 8058.27,
      "positionQty": 10,
      "positionCost": -0.001241,
      "funding": -464e-6,
      "settleCurrency": "XBT"
    },
    ...
  ],
  "hasMore": true
}
```
"""
function private_funding_history(client::KucoinClient, query::PrivateFundingHistoryQuery)
    return APIsRequest{Vector{PrivateFundingHistoryData}}("GET", "api/v1/funding-history", query)(client)
end

function private_funding_history(client::KucoinClient; kw...)
    return private_funding_history(client, PrivateFundingHistoryQuery(; kw...))
end

end
