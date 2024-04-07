module Currency

export CurrencyQuery,
    CurrencyData,
    currency

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Gateio
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrencyQuery <: GateioPublicQuery
    #__ empty
end

struct CurrencyData <: GateioData
    chain::String
    currency::String
    delisted::Bool
    deposit_disabled::Bool
    fixed_rate::Maybe{Float64}
    trade_disabled::Bool
    withdraw_delayed::Bool
    withdraw_disabled::Bool
end

"""
    currency(client::GateioClient, query::CurrencyQuery)
    currency(client::GateioClient = Gateio.Spot.public_client; kw...)

List all currencies' details.

[`GET api/v4/spot/currencies`](https://www.gate.io/docs/developers/apiv4/#list-all-currencies-details)

## Code samples:

```julia
using Serde
using CryptoAPIs.Gateio

result = Gateio.Spot.currency()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "chain":"BSC",
    "currency":"100X",
    "delisted":false,
    "deposit_disabled":true,
    "fixed_rate":null,
    "trade_disabled":true,
    "withdraw_delayed":false,
    "withdraw_disabled":false
  },
  ...
]
```
"""
function currency(client::GateioClient, query::CurrencyQuery)
    return APIsRequest{Vector{CurrencyData}}("GET", "api/v4/spot/currencies", query)(client)
end

function currency(client::GateioClient = Gateio.Spot.public_client; kw...)
    return currency(client, CurrencyQuery(; kw...))
end

end
