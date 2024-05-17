module WithdrawalLog

export WithdrawalLogQuery,
    WithdrawalLogData,
    withdrawal_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawalLogQuery <: KrakenPrivateQuery
    asset::String
    method::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

@enum Status begin
    Initial
    Pending
    Settled
    Success
    Failure
end

struct WithdrawalLogData <: KrakenData
    aclass::String
    amount::Float64
    asset::String
    fee::Float64
    info::String
    method::String
    refid::String
    status::Status
    status_prop::Maybe{Status}
    time::NanoDate
    txid::String
end

"""
    withdrawal_log(client::KrakenClient, query::WithdrawalLogQuery)
    withdrawal_log(client::KrakenClient; kw...)

Retrieve information about recent withdrawals.

[`POST 0/private/WithdrawStatus`](https://docs.kraken.com/rest/#tag/Funding/operation/getStatusRecentWithdrawals)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| asset     | String     | true     |             |
| method    | String     | false    |             |
| nonce     | DateTime   | false    |             |
| signature | String     | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kraken

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.Spot.withdrawal_log(
    kraken_client;
    asset = "XBT"
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":[
    {
      "method":"Bitcoin",
      "aclass":"currency",
      "asset":"XXBT",
      "refid":"FTQcuak-V6Za8qrPnhsTx47yYLz8Tg",
      "txid":"29323ce212ceb2daf81255cbea8a5...ad7a626471e05e1f82929501e82934",
      "info":"bc1qa35ls....3egf0872h3w",
      "amount":0.72485,
      "fee":0.0002,
      "time":"2023-06-29T05:10:23",
      "status":Pending,
      "status_prop":null,
    },
    ...
  ]
}
```
"""
function withdrawal_log(client::KrakenClient, query::WithdrawalLogQuery)
    return APIsRequest{Data{Vector{WithdrawalLogData}}}("POST", "0/private/WithdrawStatus", query)(client)
end

aclass::String
amount::Float64
asset::String
fee::Float64
info::String
method::String
refid::String
status::Status
status_prop::Maybe{Status}
time::NanoDate
txid::String

function withdrawal_log(client::KrakenClient; kw...)
    return withdrawal_log(client, WithdrawalLogQuery(; kw...))
end

end
