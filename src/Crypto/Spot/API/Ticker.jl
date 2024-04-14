module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Crypto
using CryptoAPIs.Crypto: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: CryptoPublicQuery
    instrument_name::Maybe{String} = nothing
end

struct TickerStruct <:CryptoData
    h::Maybe{String}
    l::Maybe{String}
    a::Maybe{String}
    i::Maybe{String}
    v::Maybe{String}
    vv::Maybe{String}
    oi::Maybe{String}
    c::Maybe{String}
    b::Maybe{String}
    k::Maybe{String}
    t::Maybe{Int64}
end

struct TickerData <: CryptoData
    data::Vector{TickerStruct}
end

"""
    ticker(client::CryptoClient, query::TickerQuery)
    ticker(client::CryptoClient = Crypto.Spot.public_client; kw...)

Fetches the public tickers for all or a particular instrument.

[`GET public/get-tickers`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-tickers)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| instrument_name | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Crypto

result = Crypto.Spot.ticker(; instrument_name = "BTCUSD-PERP") 

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":-1,
  "method":"public/get-tickers",
  "code":"0",
  "result":{
    "data":[
      {
        "h":"67273.3",
        "l":"60120.8",
        "a":"64502.3",
        "i":"BTCUSD-PERP",
        "v":"12027.5429",
        "vv":"770370279.39",
        "oi":"1805.8306",
        "c":"-0.0394",
        "b":"64493.6",
        "k":"64501.4",
        "t":1713114666097
      }
    ]
  }
}
```
"""
function ticker(client::CryptoClient, query::TickerQuery)
    return APIsRequest{Data{TickerData}}("GET", "public/get-tickers", query)(client)
end

function ticker(client::CryptoClient = Crypto.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end