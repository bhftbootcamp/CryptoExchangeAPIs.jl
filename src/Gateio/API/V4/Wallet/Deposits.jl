module Deposits

export DepositsQuery,
    DepositsData,
    deposits

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx RecordStatus begin
    DONE
    CANCEL
    REQUEST
    MANUAL
    BCODE
    EXTPEND
    FAIL
    INVALID
    VERIFY
    PROCES
    PEND
    DMOVE
    SPLITPEND
end

Base.@kwdef mutable struct DepositsQuery <: GateioPrivateQuery
    currency::Maybe{String} = nothing
    from::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    offset::Maybe{Int64} = nothing
    to::Maybe{DateTime} = nothing

    signature::Maybe{String} = nothing
    signTimestamp::Maybe{DateTime} = nothing
end

struct DepositsData <: GateioData
    address::String
    amount::Float64
    chain::String
    currency::String
    fee::Maybe{Float64}
    id::Int64
    memo::Maybe{String}
    status::RecordStatus.T
    timestamp::NanoDate
    txid::Int128
    withdraw_order_id::String
end

function Serde.isempty(::Type{<:DepositsData}, x)::Bool
    return x === ""
end

"""
    deposits(client::GateioClient, query::CandleQuery)
    deposits(client::GateioClient; kw...)

Retrieve deposit records.

[`GET api/v4/wallet/deposits`](https://www.gate.io/docs/developers/apiv4/#retrieve-deposit-records)

## Parameters:

| Parameter     | Type     | Required | Description |
|:--------------|:---------|:---------|:------------|
| currency      | String   | false    |             |
| from          | DateTime | false    |             |
| limit         | Int64    | false    |             |
| offset        | Int64    | false    |             |
| to            | DateTime | false    |             |
| sign          | String   | false    |             |
| signTimestamp | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

gateio_client = GateioClient(;
    base_url = "https://api.Gateio.ws",
    public_key = ENV["GATEIO_PUBLIC_KEY"],
    secret_key = ENV["GATEIO_SECRET_KEY"],
)

result = Gateio.API.V4.Wallet.deposits(gateio_client)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "address": "1HkxtBAMrA3tP5EYY2CZortjZvFDH5Cs",
    "amount": 222.61,
    "chain": "TRX"
    "currency": "USDT",
    "fee": null,
    "id": 210496,
    "memo": null,
    "status": "DONE",
    "timestamp": "2018-11-12T05:20:00",
    "txid": 128988928203223323290,
    "withdraw_order_id": "order_123456",
  },
  ...
]
```
"""
function deposits(client::GateioClient, query::DepositsQuery)
    return APIsRequest{Vector{DepositsData}}("GET", "api/v4/wallet/deposits", query)(client)
end

function deposits(client::GateioClient; kw...)
    return deposits(client, DepositsQuery(; kw...))
end

end
