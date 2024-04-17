module Currency

export CurrencyQuery,
    CurrencyData,
    currency

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Okex
using CryptoAPIs.Okex: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct CurrencyQuery <: OkexPrivateQuery
    ccy::String = ""

    signature::Maybe{String} = nothing
    timestamp::Maybe{DateTime} = nothing
end

struct CurrencyData <: OkexData
    canDep::Bool
    canInternal::Bool
    canWd::Bool
    ccy::String
    chain::String
    depQuotaFixed::Maybe{Float64}
    depQuoteDailyLayer2::Maybe{Int64}
    logoLink::Maybe{String}
    mainNet::Bool
    maxFee::Float64
    maxWd::Float64
    minDep::Float64
    minDepArrivalConfirm::Maybe{Int64}
    minFee::Float64
    minWd::Float64
    minWdUnlockConfirm::Maybe{Int64}
    name::Maybe{String}
    needTag::Bool
    usedDepQuotaFixed::Maybe{Float64}
    usedWdQuota::Maybe{Int64}
    wdQuota::Maybe{Int64}
    wdTickSz::Maybe{Int64}
end

function Serde.isempty(::Type{<:CurrencyData}, x)::Bool
    return isempty(x)
end

"""
    currency(client::OkexClient, query::CurrencyQuery)
    currency(client::OkexClient; kw...)

Get information of coins (available for deposit and withdraw) for user.

[`GET api/v5/asset/currencies`](https://www.okx.com/docs-v5/en/#rest-api-funding-get-currencies)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| ccy       | String   | false    |             |
| signature | String   | false    |             |
| timestamp | DateTime | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Okex

okex_client = OkexClient(;
    base_url = "https://www.okex.com",
    public_key = ENV["OKEX_PUBLIC_KEY"],
    secret_key = ENV["OKEX_SECRET_KEY"],
    passphrase = ENV["OKEX_PASSPHRASE"],
)

result = Okex.Spot.currency(okex_client; ccy = "BTC")

to_pretty_json(result.result)
```

## Result:

```json
{
  "msg":"",
  "code":0,
  "data":[
    {
      "canDep":true,
      "canInternal":true,
      "canWd":true,
      "ccy":"BTC",
      "chain":"BTC-Bitcoin",
      "depQuotaFixed":null,
      "depQuoteDailyLayer2":null,
      "logoLink":"https://static.coinall.ltd/cdn/oksupport/asset/currency/icon/btc20230419112752.png",
      "mainNet":true,
      "maxFee":0.0006,
      "maxWd":500.0,
      "minDep":0.0005,
      "minDepArrivalConfirm":1,
      "minFee":0.0003,
      "minWd":0.001,
      "minWdUnlockConfirm":2,
      "name":"Bitcoin",
      "needTag":false,
      "usedDepQuotaFixed":null,
      "usedWdQuota":0,
      "wdQuota":40000000,
      "wdTickSz":8
    },
    ...
  ]
}
```
"""
function currency(client::OkexClient, query::CurrencyQuery)
    return APIsRequest{Data{CurrencyData}}("GET", "api/v5/asset/currencies", query)(client)
end

function currency(client::OkexClient; kw...)
    return currency(client, CurrencyQuery(; kw...))
end

end
