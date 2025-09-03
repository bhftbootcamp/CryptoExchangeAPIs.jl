module Currencies

export CurrenciesQuery,
    CurrenciesData,
    currencies

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrenciesQuery <: GateioPublicQuery
    #__ empty
end

struct CurrenciesData <: GateioData
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
    currencies(client::GateioClient, query::CurrenciesQuery)
    currencies(client::GateioClient = Gateio.public_client; kw...)

List all currencies' details.

[`GET api/v4/spot/currencies`](https://www.gate.io/docs/developers/apiv4/#list-all-currencies-details)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.API.V4.Spot.currencies()

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
function currencies(client::GateioClient, query::CurrenciesQuery)
    return APIsRequest{Vector{CurrenciesData}}("GET", "api/v4/spot/currencies", query)(client)
end

function currencies(client::GateioClient = Gateio.public_client; kw...)
    return currencies(client, CurrenciesQuery(; kw...))
end

end
