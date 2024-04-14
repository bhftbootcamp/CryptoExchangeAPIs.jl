module GetInstruments

export GetInstrumentsQuery,
    GetInstrumentsData,
    get_instruments

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Crypto
using CryptoAPIs.Crypto: Data
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef struct GetInstrumentsQuery <: CryptoPublicQuery
    #__ empty
end

struct GetInstrumentsStruct <:CryptoData
    symbol::Maybe{String}
    inst_type::Maybe{String}
    display_name::Maybe{String}
    base_ccy::Maybe{String}
    quote_ccy::Maybe{String}
    quote_decimals::Maybe{Float32}
    quantity_decimals::Maybe{Float32}
    price_tick_size::Maybe{String}
    qty_tick_size::Maybe{String}
    max_leverage::Maybe{String}
    tradable::Maybe{Bool}
    expiry_timestamp_ms::Maybe{Int64}
    underlying_symbol::Maybe{String}
end

struct GetInstrumentsData <: CryptoData
    data::Vector{GetInstrumentsStruct}
end

"""
    get_instruments(client::CryptoClient, query::GetInstrumentsQuery)
    get_instruments(client::CryptoClient = Crypto.Spot.public_client; kw...)

Provides information on all supported instruments.

[`GET public/get-instruments`](https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#public-get-instruments)

## Code samples:

```julia
using Serde
using CryptoAPIs.Crypto

result = Crypto.Spot.get_instruments() 

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
        "inst_type":"CCY_PAIR",
        "display_name":"ZRX/USDT",
        "base_ccy":"ZRX",
        "quote_ccy":"USDT",
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
function get_instruments(client::CryptoClient, query::GetInstrumentsQuery)
    return APIsRequest{Data{GetInstrumentsData}}("GET", "public/get-instruments", query)(client)
end

function get_instruments(client::CryptoClient = Crypto.Spot.public_client; kw...)
    return get_instruments(client, GetInstrumentsQuery(; kw...))
end

end