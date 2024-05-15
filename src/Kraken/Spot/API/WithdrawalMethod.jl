module WithdrawalMethod

export WithdrawalMethodQuery,
    WithdrawalMethodData,
    withdrawal_method

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Kraken
using CryptoAPIs.Kraken: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawalMethodQuery <: KrakenPrivateQuery
    asset::Maybe{String} = nothing
    aclass::Maybe{String} = nothing
    network::Maybe{String} = nothing

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct WithdrawalMethodData <: KrakenData
    asset::String
    method::String
    network::String
    minimum::Float64
end

"""
    withdrawal_method(client::KrakenClient, query::WithdrawalMethodQuery)
    withdrawal_method(client::KrakenClient = Kraken.Spot.public_client; kw...)

Retrieve a list of withdrawal methods available for the user.

[`POST 0/private/WithdrawMethods`](https://docs.kraken.com/rest/#tag/Funding/operation/getWithdrawalMethods)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | false    |             |
| aclass    | String   | false    |             |
| network   | String   | false    |             |
| nonce     | DateTime | false    |             |
| signature | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Kraken

kraken_client = Kraken.KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

result = Kraken.Spot.withdrawal_method(
    kraken_client;
    asset = "XBT"
)

to_pretty_json(result.result)
```

## Result:

```json

```
"""
function withdrawal_method(client::KrakenClient, query::WithdrawalMethodQuery)
    return APIsRequest{Data{Vector{WithdrawalMethodData}}}("POST", "0/private/WithdrawMethods", query)(client)
end

function withdrawal_method(client::KrakenClient; kw...)
    return withdrawal_method(client, WithdrawalMethodQuery(; kw...))
end

end
