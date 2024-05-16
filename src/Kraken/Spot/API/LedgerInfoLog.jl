module LedgerInfoLog

export LedgerInfoLogQuery,
    LedgerInfoLogData,
    ledger_info_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

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
using CryptoAPIs.Kraken

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.Spot.ledger_info_log(
    kraken_client;
    type = CryptoAPIs.Kraken.Spot.LedgerInfoLog.margin,
    asset = "XBT",
    start = Dates.DateTime("2021-04-03T15:33:20"),
    _end = Dates.DateTime("2022-04-03T15:33:20"),
)

to_pretty_json(result.result)
```

## Result:

```json

```
"""
function ledger_info_log(client::KrakenClient, query::LedgerInfoLogQuery)
    return APIsRequest{Data{LedgerInfoLogData}}("POST", "0/private/Ledgers", query)(client)
end

function ledger_info_log(client::KrakenClient; kw...)
    return ledger_info_log(client, LedgerInfoLogQuery(; kw...))
end

end
