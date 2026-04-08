module FundingRateHistory

export FundingRateHistoryQuery,
    FundingRateHistoryData,
    funding_rate_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct FundingRateHistoryQuery <: MexcPublicQuery
    symbol::String
    page_num::Maybe{Int64} = nothing
    page_size::Maybe{Int64} = nothing
end

struct FundingRateRecord <: MexcData
    symbol::Maybe{String}
    fundingRate::Maybe{Float64}
    settleTime::Maybe{NanoDate}
end

struct FundingRateHistoryData <: MexcData
    pageSize::Maybe{Int64}
    totalCount::Maybe{Int64}
    totalPage::Maybe{Int64}
    currentPage::Maybe{Int64}
    resultList::Vector{FundingRateRecord}
end

"""
    funding_rate_history(client::MexcClient, query::FundingRateHistoryQuery)
    funding_rate_history(client::MexcClient = Mexc.Futures.public_client; kw...)

Get contract funding rate history.

[`GET api/v1/contract/funding_rate/history`](https://mexcdevelop.github.io/apidocs/contract_v1_en/#get-contract-funding-rate-history)

## Parameters:

| Parameter | Type   | Required | Description                           |
|:----------|:-------|:---------|:--------------------------------------|
| symbol    | String | true     | Contract name, e.g. BTC_USDT          |
| page_num  | Int64  | false    | Current page number, default 1        |
| page_size | Int64  | false    | Page size, default 20, max 1000       |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.Futures.funding_rate_history(;
    symbol = "BTC_USDT",
    page_num = 1,
    page_size = 3,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "success":true,
  "code":0,
  "data":{
    "pageSize":3,
    "totalCount":1000,
    "totalPage":334,
    "currentPage":1,
    "resultList":[
      {
        "symbol":"BTC_USDT",
        "fundingRate":0.000266,
        "settleTime":"2021-01-05T00:00:00"
      },
      ...
    ]
  }
}
```
"""
function funding_rate_history(client::MexcClient, query::FundingRateHistoryQuery)
    return APIsRequest{Data{FundingRateHistoryData}}("GET", "api/v1/contract/funding_rate/history", query)(client)
end

function funding_rate_history(client::MexcClient = Mexc.Futures.public_client; kw...)
    return funding_rate_history(client, FundingRateHistoryQuery(; kw...))
end

end
