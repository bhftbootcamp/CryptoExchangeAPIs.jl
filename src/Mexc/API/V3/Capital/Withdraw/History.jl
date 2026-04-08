module History

export HistoryQuery,
    HistoryData,
    history

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct HistoryQuery <: MexcSpotPrivateQuery
    coin::Maybe{String} = nothing
    status::Maybe{Int64} = nothing
    limit::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing

    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct HistoryData <: MexcData
    id::Maybe{String}
    txId::Maybe{String}
    coin::Maybe{String}
    network::Maybe{String}
    address::Maybe{String}
    amount::Maybe{String}
    transferType::Maybe{Int64}
    status::Maybe{Int64}
    transactionFee::Maybe{String}
    confirmNo::Maybe{String}
    applyTime::Maybe{NanoDate}
    remark::Maybe{String}
    memo::Maybe{String}
    transHash::Maybe{String}
    updateTime::Maybe{NanoDate}
    coinId::Maybe{String}
    vcoinId::Maybe{String}
end

"""
    history(client::MexcClient, query::HistoryQuery)
    history(client::MexcClient; kw...)

Fetch withdraw history.

[`GET api/v3/capital/withdraw/history`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#withdraw-history-supporting-network)

## Parameters:

| Parameter | Type     | Required | Description                                                                               |
|:----------|:---------|:---------|:------------------------------------------------------------------------------------------|
| coin      | String   | false    |                                                                                           |
| status    | Int64    | false    | 1:APPLY 2:AUDITING 3:WAIT 4:PROCESSING 5:WAIT_PACKAGING 6:WAIT_CONFIRM 7:SUCCESS ...   |
| limit     | Int64    | false    | Default 1000; max 1000                                                                    |
| startTime | DateTime | false    | Default: 7 days ago                                                                       |
| endTime   | DateTime | false    | Default: current time                                                                     |
| timestamp | DateTime | false    |                                                                                           |
| signature | String   | false    |                                                                                           |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

mexc_client = MexcClient(;
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

result = Mexc.API.V3.Capital.Withdraw.history(mexc_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":"bb17a2d452684f00a523c015d512a341",
    "txId":null,
    "coin":"EOS",
    "network":"EOS",
    "address":"zzqqqqqqqqqq",
    "amount":"10",
    "transferType":0,
    "status":3,
    "transactionFee":"0",
    "confirmNo":null,
    "applyTime":"2022-10-09T11:54:34",
    "remark":"",
    "memo":"MX10086",
    "transHash":"0x0ced593b8b5adc9f600334d0d7335456a7ed772...",
    "updateTime":"2024-04-03T12:28:02",
    "coinId":"128f589271cb495b03e71e6323eb7be",
    "vcoinId":"af42c6414b9a46c8869ce30fd51660f"
  },
  ...
]
```
"""
function history(client::MexcClient, query::HistoryQuery)
    return APIsRequest{Vector{HistoryData}}("GET", "api/v3/capital/withdraw/history", query)(client)
end

function history(client::MexcClient; kw...)
    return history(client, HistoryQuery(; kw...))
end

end
