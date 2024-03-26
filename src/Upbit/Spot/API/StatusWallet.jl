module StatusWallet

export StatusWalletQuery,
    StatusWalletData,
    status_wallet

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Upbit
using CryptoAPIs: Maybe, APIsRequest

@enum WalletState working withdraw_only deposit_only paused unsupported

@enum BlockState normal delayed inactive

Base.@kwdef mutable struct StatusWalletQuery <: UpbitPrivateQuery
    signature::Maybe{String} = nothing
end

struct StatusWalletData <: UpbitData
    block_height::Maybe{Int64}
    block_state::Maybe{BlockState}
    block_updated_at::Maybe{NanoDate}
    block_elapsed_minutes::Maybe{Int64}
    currency::String
    net_type::String
    wallet_state::WalletState
    network_name::String
end

"""
    status_wallet(client::UpbitClient, query::StatusWalletQuery)
    status_wallet(client::UpbitClient; kw...)

Balance information.

[`GET v1/status/wallet`](https://docs.upbit.com/reference/입출금-현황)

## Parameters:

| Paramete  | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| signature | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Upbit

result = Upbit.Spot.status_wallet() 

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "currency": "KLAY",
    "wallet_state": "working",
    "block_state": "normal",
    "block_height": 7235123,
    "block_updated_at": "2019-02-18T07:08:50.499+00:00",
    "block_elapsed_minutes": 2502349,
    "net_type": "KLAY",
    "network_name": "Klaytn"
  },
  ...
]
```
"""
function status_wallet(client::UpbitClient, query::StatusWalletQuery)
    return APIsRequest{Vector{StatusWalletData}}("GET", "v1/status/wallet", query)(client)
end

function status_wallet(client::UpbitClient; kw...)
    return status_wallet(client, StatusWalletQuery(; kw...))
end

end