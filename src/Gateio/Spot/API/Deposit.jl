module Deposit

export DepositQuery,
    DepositData,
    deposit

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositQuery <: GateioPrivateQuery
    currency::Maybe{String} = nothing
    from::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing
    offset::Maybe{Int64} = nothing
    to::Maybe{DateTime} = nothing

    sign::Maybe{String} = nothing
    signTimestamp::Maybe{DateTime} = nothing
end

@enum RecordStatus DONE CANCEL REQUEST MANUAL BCODE EXTPEND FAIL INVALID VERIFY PROCES PEND DMOVE SPLITPEND

struct DepositData <: GateioData
    address::String
    amount::Float64
    chain::String
    currency::String
    fee::Maybe{Float64}
    id::Int64
    memo::Maybe{String}
    status::RecordStatus
    timestamp::NanoDate
    txid::Int128
    withdraw_order_id::String
end

function Serde.isempty(::Type{<:DepositData}, x)::Bool
    return x === ""
end

"""
    deposit(client::GateioClient, query::CandleQuery)
    deposit(client::GateioClient; kw...)

Retrieve deposit records

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
using CryptoAPIs.Gateio

gateio_client = GateioClient(;
    base_url = "https://api.Gateio.ws",
    public_key = ENV["GATEIO_PUBLIC_KEY"],
    secret_key = ENV["GATEIO_SECRET_KEY"],
)

result = Gateio.Spot.deposit(gateio_client)

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
function deposit(client::GateioClient, query::DepositQuery)
    return APIsRequest{Vector{DepositData}}("GET", "api/v4/wallet/deposits", query)(client)
end

function deposit(client::GateioClient; kw...)
    return deposit(client, DepositQuery(; kw...))
end

end
