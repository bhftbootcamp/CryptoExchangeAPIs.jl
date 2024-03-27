module Deposit

export DepositQuery,
    DepositData,
    deposit

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bybit
using CryptoAPIs.Bybit: Data, List, Rows
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct DepositQuery <: BybitPrivateQuery
    coin::Maybe{String} = nothing
    cursor::Maybe{String} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Int64 = 50                       # Default value is 50, max 50
    startTime::Maybe{DateTime} = nothing

    api_key::Maybe{String} = nothing
    recv_window::Maybe{Int64} = 5000
    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct DepositData <: BybitData
    amount::Float64
    blockHash::Maybe{String}
    chain::String
    coin::String
    confirmations::Maybe{Int64}
    depositFee::Maybe{Float64}
    status::Maybe{Int64}
    successAt::NanoDate
    tag::Maybe{String}
    toAddress::Maybe{String}
    txID::Maybe{String}
    txIndex::Maybe{Int64}
end

function Serde.isempty(::Type{DepositData}, x)::Bool
    return x === ""
end

"""
    deposit(client::BybitClient, query::DepositQuery)
    deposit(client::BybitClient; kw...)

Query Deposit Records.

[`GET asset/v3/private/deposit/record/query`](https://bybit-exchange.github.io/docs/account-asset/deposit-record)

## Parameters:

| Parameter   | Type     | Required | Description                                   |
|:------------|:---------|:---------|:----------------------------------------------|
| coin        | String   | false    |                                               |
| cursor      | String   | false    |                                               |
| endTime     | DateTime | false    |                                               |
| limit       | Int64    | false    | Default value is 50, max 50                   |
| startTime   | DateTime | false    |                                               |
| api_key     | String   | false    |                                               |
| recv_window | Int64    | false    | Default value is 5000                         |
| signature   | String   | false    |                                               |
| timestamp   | DateTime | false    |                                               |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bybit

result = Bybit.Spot.deposit(;
    ...
)

to_pretty_json(result.result)
```

## Result:

```json
{
    ...
}
```
"""
function deposit(client::BybitClient, query::DepositQuery)
    return APIsRequest{Data{Rows{DepositData}}}("GET", "asset/v3/private/deposit/record/query", query)(client)
end

function deposit(client::BybitClient; kw...)
    return deposit(client, DepositQuery(; kw...))
end

end
