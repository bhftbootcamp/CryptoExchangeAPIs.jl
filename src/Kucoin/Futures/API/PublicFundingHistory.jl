module PublicFundingHistory

export PublicFundingHistoryQuery,
    PublicFundingHistoryData,
    public_funding_history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data, Page
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct PublicFundingHistoryQuery <: KucoinPublicQuery
    symbol::String
    from::NanoDate
    to::NanoDate
end

struct PublicFundingHistoryData <: KucoinData
    symbol::String
    timepoint::Maybe{NanoDate}
    fundingRate::Maybe{Float64}
end

"""
    public_funding_history(client::KucoinClient, query::PublicFundingHistoryQuery)
    public_funding_history(client::KucoinClient = Kucoin.Futures.public_client; kw...)

Query the funding rate at each settlement time point within a certain time range of the corresponding contract.

[`GET api/v1/contract/funding-rates`](https://www.kucoin.com/docs/rest/futures-trading/funding-fees/get-public-funding-history)

## Parameters:

| Parameter  | Type     | Required | Description                  |
|:---------- |:---------|:---------|:-----------------------------|
| symbol     | String   | true     |                              |
| from       | NanoDate | false    |                              |
| to         | NanoDate | false    |                              |

## Code samples:

```julia
using Serde
using NanoDates
using CryptoExchangeAPIs.Kucoin

result = Kucoin.Futures.public_funding_history(; 
    symbol = "IDUSDTM",
    from = NanoDate("2023-11-18T12:31:40"),
    to = NanoDate("2023-12-11T16:05:00"),
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "code":200000,
  "data":[
    {
      "symbol":"IDUSDTM",
      "timepoint":"2023-12-11T12:00:00",
      "fundingRate":0.000226
    },
   ...
  ]
}
```
"""
function public_funding_history(client::KucoinClient, query::PublicFundingHistoryQuery)
    return APIsRequest{Data{Vector{PublicFundingHistoryData}}}("GET", "api/v1/contract/funding-rates", query)(client)
end

function public_funding_history(client::KucoinClient = Kucoin.Futures.public_client; kw...)
    return public_funding_history(client, PublicFundingHistoryQuery(; kw...))
end

end
