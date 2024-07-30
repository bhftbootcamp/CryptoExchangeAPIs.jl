module DepositLog

export DepositLogQuery,
    DepositLogData,
    deposit_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositLogQuery <: KrakenPrivateQuery
    asset::String
    method::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

@enum StatusProp begin
    cancel_pending          # cancelation requested
    canceled                # canceled
    cancel_denied           # cancelation requested but was denied
    _return                 # a return transaction initiated by Kraken; it cannot be canceled
    onhold                  # withdrawal is on hold pending review
end

struct DepositLogData <: KrakenData
    aclass::String
    amount::Float64
    asset::String
    fee::Float64
    info::String
    method::String
    refid::String
    status::String
    status_prop::Maybe{StatusProp}
    time::NanoDate
    txid::String
end

function Serde.deser(::Type{DepositLogData}, ::Type{StatusProp}, x::String)::StatusProp
    x == "cancel-pending" && return cancel_pending
    x == "canceled"       && return canceled
    x == "cancel-denied"  && return cancel_denied
    x == "return"         && return _return
    x == "onhold"         && return onhold
end

"""
    deposit_log(client::KrakenClient, query::DepositLogQuery)
    deposit_log(client::KrakenClient; kw...)

Retrieve information about recent deposits. Any deposits initiated in the past 90 days will be included in the response.

[`POST 0/private/DepositStatus`](https://docs.kraken.com/rest/#tag/Funding/operation/getStatusRecentDeposits)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | true     |             |
| method    | String   | false    |             |
| nonce     | DateTime | false    |             |
| signature | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kraken

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.Spot.deposit_log(
    kraken_client;
    asset = "XBT",
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
      "refid":"FTQcuak-V6Za8qrWnhzTx67yYHz8Tg",
      "txid":"6544b41b607d8b2512baf801755a3a87b6890eacdb451be8a94059fb11f0a8d9",
      "info":"2Myd4eaAW96ojk38A2uDK4FbioCayvkEgVq",
      "amount":0.78125,
      "fee":0.0,
      "time":"2023-07-10T12:38:42",
      "status":"Success",
      "status_prop":"return"
    },
    ...
  ]
}
```
"""
function deposit_log(client::KrakenClient, query::DepositLogQuery)
    return APIsRequest{Data{Vector{DepositLogData}}}("POST", "0/private/DepositStatus", query)(client)
end

function deposit_log(client::KrakenClient; kw...)
    return deposit_log(client, DepositLogQuery(; kw...))
end

end
