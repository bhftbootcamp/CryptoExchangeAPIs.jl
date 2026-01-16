module InsuranceFund

export InsuranceFundQuery,
    InsuranceFundData,
    insurance_fund

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Okx
using CryptoExchangeAPIs.Okx: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx InstType begin
    MARGIN
    SWAP
    FUTURES
    OPTION
end

@enumx InsuranceFundType begin
    regular_update
    liquidation_balance_deposit
    bankruptcy_loss
    platform_revenue
    adl
end

@enumx ADLType begin
    rate_adl_start
    bal_adl_start
    pos_adl_start
    adl_end
end

Base.@kwdef struct InsuranceFundQuery <: OkxPublicQuery
    instType::InstType.T
    type::Maybe{InsuranceFundType.T} = nothing
    instFamily::Maybe{String} = nothing
    ccy::Maybe{String} = nothing
    before::Maybe{DateTime} = nothing
    after::Maybe{DateTime} = nothing
    limit::Maybe{Int} = nothing
end

struct InsuranceFundDetail <: OkxData
    balance::Float64
    amt::Maybe{Float64}
    ccy::String
    type::InsuranceFundType.T
    maxBal::Maybe{Float64}
    maxBalTs::Maybe{NanoDate}
    adlType::Maybe{ADLType.T}
    ts::NanoDate
end

struct InsuranceFundData <: OkxData
    total::Float64
    instFamily::Maybe{String}
    instType::InstType.T
    details::Vector{InsuranceFundDetail}
end

Serde.isempty(::Type{InsuranceFundDetail}, x::String) = isempty(x)
Serde.isempty(::Type{InsuranceFundData}, x::String) = isempty(x)

"""
    insurance_fund(client::OkxClient, query::InsuranceFundQuery)
    insurance_fund(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)

Get security fund balance information.

[`GET api/v5/public/insurance-fund`](https://www.okx.com/docs-v5/en/#public-data-rest-api-get-security-fund)

## Parameters:

| Parameter  | Type              | Required | Description                                                                         |
|:-----------|:------------------|:---------|:------------------------------------------------------------------------------------|
| instType   | InstType          | true     | MARGIN, SWAP, FUTURES, OPTION                                                       |
| type       | InsuranceFundType | false    | regular_update, liquidation_balance_deposit, bankruptcy_loss, platform_revenue, adl |
| instFamily | String            | false    | Required for FUTURES/SWAP/OPTION                                                    |
| ccy        | String            | false    | Only applicable to MARGIN                                                           |
| before     | DateTime          | false    |                                                                                     |
| after      | DateTime          | false    |                                                                                     |
| limit      | Int               | false    |                                                                                     |

## Code samples:

```julia
using CryptoExchangeAPIs.Okx

result = Okx.API.V5.Public.insurance_fund(;
    instType = Okx.API.V5.Public.InsuranceFund.InstType.FUTURES,
    instFamily = "BTC-USDT",
)
```
"""
function insurance_fund(client::OkxClient, query::InsuranceFundQuery)
    return APIsRequest{Data{InsuranceFundData}}("GET", "api/v5/public/insurance-fund", query)(client)
end

function insurance_fund(client::OkxClient = Okx.OkxClient(Okx.public_config); kw...)
    return insurance_fund(client, InsuranceFundQuery(; kw...))
end

end