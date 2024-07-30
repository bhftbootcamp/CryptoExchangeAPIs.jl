module DepositMethod

export DepositMethodQuery,
    DepositMethodData,
    deposit_method

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositMethodQuery <: KrakenPrivateQuery
    asset::String

    nonce::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct DepositMethodData <: KrakenData
    method::String
    limit::Float64
    fee::Maybe{Float64}
    address_setup_fee::Maybe{String}
    gen_address::Maybe{Bool}
end

function Serde.custom_name(::Type{DepositMethodData}, ::Val{:address_setup_fee})::String
    return "address-setup-fee"
end

function Serde.custom_name(::Type{DepositMethodData}, ::Val{:gen_address})::String
    return "gen-address"
end

"""
    deposit_method(client::KrakenClient, query::DepositMethodQuery)
    deposit_method(client::KrakenClient; kw...)

Retrieve methods available for depositing a particular asset.

[`POST 0/private/DepositMethods`](https://docs.kraken.com/rest/#tag/Funding/operation/getDepositMethods)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| asset     | String   | true     |             |
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

result = Kraken.Spot.deposit_method(
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
      "limit":false,
      "fee":"0.0000000000",
      "gen_address":true,
    },
    ...
  ]
}
```
"""
function deposit_method(client::KrakenClient, query::DepositMethodQuery)
    return APIsRequest{Data{Vector{DepositMethodData}}}("POST", "0/private/DepositMethods", query)(client)
end

function deposit_method(client::KrakenClient; kw...)
    return deposit_method(client, DepositMethodQuery(; kw...))
end

end
