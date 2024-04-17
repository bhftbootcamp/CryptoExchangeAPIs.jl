module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Cryptocom
using CryptoAPIs.Cryptocom: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: CryptocomPublicQuery
    instrument_name::Maybe{String} = nothing
end

struct TickerInfo <:CryptocomData
    h::Float64
    l::Maybe{Float64}
    a::Maybe{Float64}
    i::String
    v::Float64
    vv::Float64
    oi::Float64
    c::Maybe{Float64}
    b::Maybe{Float64}
    k::Maybe{Float64}
    t::Int64
end

function Serde.isempty(::Type{TickerInfo}, x)::Bool
  return x === ""
end

struct TickerData <: CryptocomData
    data::Vector{TickerInfo}
end

function Serde.isempty(::Type{TickerData}, x)::Bool
  return x == []
end

"""
    ticker(client::CryptocomClient, query::TickerQuery)
    ticker(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)

Fetches the public tickers for all or a particular instrument.

[`GET public/get-tickers`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-tickers)

## Parameters:

| Parameter       | Type     | Required | Description |
|:----------------|:---------|:---------|:------------|
| instrument_name | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Cryptocom

result = Cryptocom.Spot.ticker(; instrument_name = "BTCUSD-PERP") 

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
function ticker(client::CryptocomClient, query::TickerQuery)
    return APIsRequest{Data{TickerData}}("GET", "public/get-tickers", query)(client)
end

function ticker(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end