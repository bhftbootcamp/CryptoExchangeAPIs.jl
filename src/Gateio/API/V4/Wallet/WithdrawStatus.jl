module WithdrawStatus

export WithdrawStatusQuery,
    WithdrawStatusData,
    withdraw_status

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct WithdrawStatusQuery <: GateioPrivateQuery
    currency::String

    signature::Maybe{String} = nothing
    signTimestamp::Maybe{DateTime} = nothing
end

struct WithdrawStatusData <: GateioData
    currency::String
    name::String
    name_cn::Maybe{String}
    deposit::Maybe{Float64}
    withdraw_percent::Maybe{Float64}
    withdraw_fix::Maybe{Float64}
    withdraw_day_limit::Maybe{Float64}
    withdraw_amount_mini::Maybe{Float64}
    withdraw_day_limit_remain::Maybe{Float64}
    withdraw_eachtime_limit::Maybe{Float64}
    withdraw_fix_on_chains::Maybe{Dict{String,Float64}}
    withdraw_percent_on_chains::Maybe{Dict{String,Float64}}
end

function Serde.deser(::Type{WithdrawStatusData}, ::Type{Float64}, x::AbstractString)
    return parse(Float64, replace(x, "%" => ""))
end

function Serde.deser(
    ::Type{WithdrawStatusData},
    ::Type{Dict{String,Float64}},
    x::Dict{String,Any},
)
    return Dict{String,Float64}(
        k => Serde.deser(WithdrawStatusData, Float64, v) for (k, v) in x
    )
end

"""
    withdraw_status(client::GateioClient, query::WithdrawStatusQuery)
    withdraw_status(client::GateioClient; kw...)

Get withdrawal status

[`GET api/v4/wallet/withdraw_status`](https://www.gate.io/docs/developers/apiv4/#retrieve-withdrawal-status)

## Parameters:

| Parameter | Type   | Required | Description          |
|:----------|:-------|:---------|:---------------------|
| currency  | String | true     | Currency, uppercase  |

## Code samples:

```julia
using CryptoExchangeAPIs.Gateio

client = GateioClient(
    public_key = ENV["GATEIO_PUBLIC_KEY"],
    secret_key = ENV["GATEIO_SECRET_KEY"],
)

result = Gateio.API.V4.Wallet.withdraw_status(client, currency = "BTC")
```
"""
function withdraw_status(client::GateioClient, query::WithdrawStatusQuery)
    return APIsRequest{Vector{WithdrawStatusData}}("GET", "api/v4/wallet/withdraw_status", query)(client)
end

function withdraw_status(client::GateioClient; kw...)
    return withdraw_status(client, WithdrawStatusQuery(; kw...))
end

end
