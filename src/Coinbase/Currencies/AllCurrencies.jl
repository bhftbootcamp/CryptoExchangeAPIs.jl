module AllCurrencies

export AllCurrenciesQuery,
    AllCurrenciesData,
    all_currencies

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Coinbase
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AllCurrenciesQuery <: CoinbasePublicQuery
    #__ empty
end

struct SupportedNetwork <: CoinbaseData
    id::Maybe{String}
    name::Maybe{String}
    status::Maybe{String}
    contract_address::Maybe{String}
    crypto_address_link::Maybe{String}
    crypto_transaction_link::Maybe{String}
    min_withdrawal_amount::Maybe{Float64}
    max_withdrawal_amount::Maybe{Float64}
    network_confirmations::Maybe{Int32}
    processing_time_seconds::Maybe{Int32}
end

struct AllCurrenciesDetails <: CoinbaseData
    type::Maybe{String}
    symbol::Maybe{String}
    network_confirmations::Maybe{Int32}
    sort_order::Maybe{Int32}
    crypto_address_link::Maybe{String}
    crypto_transaction_link::Maybe{String}
    push_payment_methods::Maybe{Vector{String}}
    group_types::Maybe{Vector{String}}
    display_name::Maybe{String}
    processing_time_seconds::Maybe{Float64}
    min_withdrawal_amount::Maybe{Float64}
    max_withdrawal_amount::Maybe{Float64}
end

struct AllCurrenciesData <: CoinbaseData
    id::String
    name::Maybe{String}
    min_size::Maybe{String}
    status::Maybe{String}
    message::Maybe{String}
    max_precision::Maybe{Float64}
    convertible_to::Maybe{Vector{String}}
    details::Maybe{AllCurrenciesDetails}
    default_network::Maybe{String}
    supported_networks::Maybe{Vector{SupportedNetwork}}
end

function Serde.isempty(::Type{AllCurrenciesData}, x)::Bool
    return x === ""
end

"""
    all_currencies(client::CoinbaseClient, query::AllCurrenciesQuery)
    all_currencies(client::CoinbaseClient = Coinbase.public_client; kw...)

Gets a list of all known currencies.

[`GET currencies`](https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getcurrencies)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Coinbase

result = Coinbase.Currencies.all_currencies()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":"00",
    "name":"00 Token",
    "min_size":"0.00000001",
    "status":"online",
    "message":null,
    "max_precision":1.0e-8,
    "convertible_to":[

    ],
    "details":{
        "type":"crypto",
        "symbol":null,
        "network_confirmations":14,
        "sort_order":0,
        "crypto_address_link":"https://etherscan.io/token/0x881ba05de1e78f549cc63a8f6cabb1d4ad32250d?a={{address}}",
        "crypto_transaction_link":"https://etherscan.io/tx/0x{{txId}}",
        "push_payment_methods":[

        ],
        "group_types":[

        ],
        "display_name":null,
        "processing_time_seconds":null,
        "min_withdrawal_amount":1.0e-8,
        "max_withdrawal_amount":410000.0
    },
    "default_network":"ethereum",
    "supported_networks":[
        {
        "id":"ethereum",
        "name":"Ethereum",
        "status":"online",
        "contract_address":"0x881ba05de1e78f549cc63a8f6cabb1d4ad32250d",
        "crypto_address_link":"https://etherscan.io/token/0x881ba05de1e78f549cc63a8f6cabb1d4ad32250d?a={{address}}",
        "crypto_transaction_link":"https://etherscan.io/tx/0x{{txId}}",
        "min_withdrawal_amount":1.0e-8,
        "max_withdrawal_amount":410000.0,
        "network_confirmations":14,
        "processing_time_seconds":null
        }
    ]
  },
  ...
]
```
"""
function all_currencies(client::CoinbaseClient, query::AllCurrenciesQuery)
    return APIsRequest{Vector{AllCurrenciesData}}("GET", "currencies", query)(client)
end

function all_currencies(client::CoinbaseClient = Coinbase.public_client; kw...)
    return all_currencies(client, AllCurrenciesQuery(; kw...))
end

end
