module DepositLog

export DepositLogQuery,
    DepositLogData,
    deposit_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositLogQuery <: MexcPrivateQuery
    coin::Maybe{String} = nothing
    status::Maybe{Int64} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing

    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct DepositLogData <: MexcData
    amount::Maybe{String}
    coin::Maybe{String}
    network::Maybe{String}
    status::Maybe{Int64}
    address::Maybe{String}
    txId::Maybe{String}
    insertTime::Maybe{NanoDate}
    unlockConfirm::Maybe{String}
    confirmTimes::Maybe{String}
    memo::Maybe{String}
end

"""
    deposit_log(client::MexcClient, query::DepositLogQuery)
    deposit_log(client::MexcClient; kw...)

Fetch deposit history.

[`GET api/v3/capital/deposit/hisrec`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#deposit-history-supporting-network)

## Parameters:

| Parameter | Type     | Required | Description                                                                                 |
|:----------|:---------|:---------|:--------------------------------------------------------------------------------------------|
| coin      | String   | false    |                                                                                             |
| status    | Int64    | false    | 1:SMALL 2:TIME_DELAY 3:LARGE_DELAY 4:PENDING 5:SUCCESS 6:AUDITING 7:REJECTED 8:REFUND ... |
| startTime | DateTime | false    | Default: 7 days ago                                                                         |
| endTime   | DateTime | false    | Default: current time                                                                       |
| limit     | Int64    | false    | Default 1000; max 1000                                                                      |
| timestamp | DateTime | false    |                                                                                             |
| signature | String   | false    |                                                                                             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

mexc_client = MexcClient(;
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

result = Mexc.Spot.deposit_log(mexc_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "amount":"50000",
    "coin":"EOS",
    "network":"EOS",
    "status":5,
    "address":"0x20b7cf77db93d6ef1ab979c49142ec168427fdee",
    "txId":"01391d1c1397ef0a3cbb...",
    "insertTime":"2022-08-03T15:15:42",
    "unlockConfirm":"10",
    "confirmTimes":"241",
    "memo":"xxyy1122"
  },
  ...
]
```
"""
function deposit_log(client::MexcClient, query::DepositLogQuery)
    return APIsRequest{Vector{DepositLogData}}("GET", "api/v3/capital/deposit/hisrec", query)(client)
end

function deposit_log(client::MexcClient; kw...)
    return deposit_log(client, DepositLogQuery(; kw...))
end

end
