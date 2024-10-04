module CurrencyPairs

export CurrencyPairQuery,
    CurrencyPairsQuery,
    CurrencyPairData,
    currency_pair,
    currency_pairs

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Gateio
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct CurrencyPairQuery <: GateioPublicQuery
    currency_pair::String
end

Base.@kwdef struct CurrencyPairsQuery <: GateioPublicQuery
    #__ empty
end

struct CurrencyPairData <: GateioData
    id::String
    base::String
    var"quote"::String
    fee::Maybe{Float64}
    min_base_amount::Maybe{Float64}
    min_quote_amount::Maybe{Float64}
    max_base_amount::Maybe{Float64}
    max_quote_amount::Maybe{Float64}
    amount_precision::Maybe{Int64}
    precision::Maybe{Int64}
    trade_status::Maybe{String}
    sell_start::Maybe{NanoDate}
    buy_start::Maybe{NanoDate}
end

"""
    currency_pair(client::GateioClient, query::CurrencyPairQuery)
    currency_pair(client::GateioClient = Gateio.Spot.public_client; kw...)

Get details of a specifc currency pair.

[`GET /api/v4/spot/currency_pairs/{currency_pair}`](https://www.gate.io/docs/developers/apiv4/#get-details-of-a-specifc-currency-pair)

## Parameters:

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| currency_pair | String     | true     |             |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.Spot.currency_pair(; 
    currency_pair = "ETH_BTC",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "id":"ETH_BTC",
  "base":"ETH",
  "quote":"BTC",
  "fee":0.2,
  "min_base_amount":0.001,
  "min_quote_amount":1.0e-5,
  "max_base_amount":1000.0,
  "max_quote_amount":100.0,
  "amount_precision":4,
  "precision":6,
  "trade_status":"tradable",
  "sell_start":"1970-01-01T00:00:00",
  "buy_start":"2016-03-09T00:00:00"
}
```
"""
function currency_pair(client::GateioClient, query::CurrencyPairQuery)
    end_piont = "/api/v4/spot/currency_pairs/$(query.currency_pair)"
    return APIsRequest{CurrencyPairData}("GET", end_piont, query)(client)
end

function currency_pair(client::GateioClient = Gateio.Spot.public_client; kw...)
    return currency_pair(client, CurrencyPairQuery(; kw...))
end

"""
    currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    currency_pairs(client::GateioClient = Gateio.Spot.public_client; kw...)

List all currency pairs supported.

[`GET /api/v4/spot/currency_pairs/`](https://www.gate.io/docs/developers/apiv4/#list-all-currency-pairs-supported)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Gateio

result = Gateio.Spot.currency_pairs()

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "id":"0DOG_USDT",
    "base":"0DOG",
    "quote":"USDT",
    "fee":0.2,
    "min_base_amount":0.01,
    "min_quote_amount":3.0,
    "max_base_amount":null,
    "max_quote_amount":5.0e6,
    "amount_precision":2,
    "precision":5,
    "trade_status":"tradable",
    "sell_start":"2020-12-07T04:00:00",
    "buy_start":"2024-08-21T11:00:00"
  },
  ...
]
```
"""
function currency_pairs(client::GateioClient, query::CurrencyPairsQuery)
    end_piont = "/api/v4/spot/currency_pairs"
    return APIsRequest{Vector{CurrencyPairData}}("GET", end_piont, query)(client)
end

function currency_pairs(client::GateioClient = Gateio.Spot.public_client; kw...)
    return currency_pairs(client, CurrencyPairsQuery(; kw...))
end

end
