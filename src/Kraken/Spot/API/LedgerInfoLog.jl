module LedgerInfoLog

export LedgerInfoLogQuery,
    LedgerInfoLogData,
    ledger_info_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum LedgerType begin
    all
    deposit
    withdrawal
    trade
    margin
    rollover
    credit
    transfer
    settled
    staking
    sale
end

Base.@kwdef mutable struct LedgerInfoLogQuery <: KrakenPrivateQuery
    _end::Maybe{DateTime} = nothing
    aclass::Maybe{String} = nothing
    asset::Maybe{String} = nothing
    ofs::Maybe{Int64} = nothing
    start::Maybe{DateTime} = nothing
    type::Maybe{LedgerType} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct Ledger <: KrakenData
    aclass::Maybe{String}
    amount::Maybe{String}
    asset::Maybe{String}
    balance::Maybe{String}
    fee::Maybe{String}
    refid::Maybe{String}
    subtype::Maybe{String}
    time::NanoDate
    type::Maybe{String}
end

struct LedgerInfoLogData <: KrakenData
    count::Int64
    ledger::Dict{String,Ledger}
end

"""
    ledger_info_log(client::KrakenClient, query::LedgerInfoLogQuery)
    ledger_info_log(client::KrakenClient; kw...)

Retrieve information about ledger entries. 50 results are returned at a time, the most recent by default.

[`POST 0/private/Ledgers`](https://docs.kraken.com/rest/#tag/Account-Data/operation/getLedgers)

## Parameters:

| Parameter | Type       | Required | Description |
|:----------|:-----------|:---------|:------------|
| _end      | DateTime   | false    |             |
| aclass    | String     | false    |             |
| asset     | String     | false    |             |
| ofs       | Int64      | false    |             |
| start     | DateTime   | false    |             |
| type      | LedgerType | false    | `all` `deposit` `withdrawal` `trade` `margin` `rollover` `credit` `transfer` `settled` `staking` `sale` |
| nonce     | DateTime   | false    |             |
| signature | String     | false    |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Kraken

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.Spot.ledger_info_log(
    kraken_client;
    type = CryptoExchangeAPIs.Kraken.Spot.LedgerInfoLog.margin,
    asset = "XBT",
    start = Dates.DateTime("2021-04-03T15:33:20"),
    _end = Dates.DateTime("2022-04-03T15:33:20"),
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "error":[],
  "result":{
    "ledger":{
      "L4UESK-KG3EQ-UFO4T5":{
        "refid":"TJKLXF-PGMUI-4NTLXU",
        "time":"2023-07-04T09:54:44.178700032",
        "type":"trade",
        "subtype":"",
        "aclass":"currency",
        "asset":"ZGBP",
        "amount":-24.5,
        "fee":0.049,
        "balance":459567.9171
      },
      ...
    },
    "count":2
  }
}
```
"""
function ledger_info_log(client::KrakenClient, query::LedgerInfoLogQuery)
    return APIsRequest{Data{LedgerInfoLogData}}("POST", "0/private/Ledgers", query)(client)
end

function ledger_info_log(client::KrakenClient; kw...)
    return ledger_info_log(client, LedgerInfoLogQuery(; kw...))
end

end
