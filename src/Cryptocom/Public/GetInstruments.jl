module GetInstruments

export GetInstrumentsQuery,
    GetInstrumentsData,
    get_instruments

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Cryptocom
using CryptoExchangeAPIs.Cryptocom: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct GetInstrumentsQuery <: CryptocomPublicQuery
    #__ empty
end

struct InstrumentInfo <: CryptocomData
    symbol::String
    base_ccy::String
    quote_ccy::String
    inst_type::String
    display_name::String
    quote_decimals::Int64
    quantity_decimals::Int64
    price_tick_size::Float64
    qty_tick_size::Float64
    max_leverage::Int64
    tradable::Bool
    expiry_timestamp_ms::Int64
    underlying_symbol::Maybe{String}
end

function Serde.isempty(::Type{InstrumentInfo}, x)::Bool
    return x === ""
end

struct GetInstrumentsData <: CryptocomData
    data::Vector{InstrumentInfo}
end

function Serde.isempty(::Type{GetInstrumentsData}, x)::Bool
    return x == []
end

"""
    get_instruments(client::CryptocomClient, query::GetInstrumentsQuery)
    get_instruments(client::CryptocomClient = Cryptocom.Spot.public_client; kw...)

Provides information on all supported instruments.

[`GET public/get-instruments`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-instruments)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Cryptocom

result = Cryptocom.Spot.get_instruments() 

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":-1,
  "method":"public/get-instruments",
  "code":"0",
  "result":{
    "data":[
      {
        "symbol":"ZRX_USDT",
        "base_ccy":"ZRX",
        "quote_ccy":"USDT",
        "inst_type":"CCY_PAIR",
        "display_name":"ZRX/USDT",
        "quote_decimals":5.0,
        "quantity_decimals":0.0,
        "price_tick_size":"0.00001",
        "qty_tick_size":"1",
        "max_leverage":"50",
        "tradable":true,
        "expiry_timestamp_ms":0,
        "underlying_symbol":null
      },
      ...
    ]
  }
}
```
"""
function get_instruments(client::CryptocomClient, query::GetInstrumentsQuery)
    return APIsRequest{Data{GetInstrumentsData}}("GET", "public/get-instruments", query)(client)
end

function get_instruments(client::CryptocomClient = Cryptocom.public_client; kw...)
    return get_instruments(client, GetInstrumentsQuery(; kw...))
end

end
