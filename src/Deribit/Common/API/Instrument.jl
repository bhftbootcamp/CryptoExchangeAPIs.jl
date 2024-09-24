module Instrument

export InstrumentQuery,
    InstrumentData,
    instrument

export Currency,
    InstrumentKind

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Currency BTC ETH USDC USDT

@enum InstrumentKind begin
    future
    option
    future_combo
    option_combo
    spot
end

Base.@kwdef struct InstrumentQuery <: DeribitPublicQuery
    currency::Currency
    expired::Maybe{Bool} = nothing
    kind::Maybe{InstrumentKind} = nothing
end

@enum FutureType linear reversed

@enum OptionType put call

struct InstrumentData <: DeribitData
    base_currency::Maybe{String}
    block_trade_commission::Maybe{Float64}
    block_trade_min_trade_amount::Maybe{Float64}
    block_trade_tick_size::Maybe{Float64}
    contract_size::Maybe{Float64}
    counter_currency::Maybe{String}
    creation_timestamp::NanoDate
    expiration_timestamp::NanoDate
    future_type::Maybe{FutureType}
    instrument_id::Int64
    instrument_name::Maybe{String}
    instrument_type::Maybe{String}
    is_active::Bool
    kind::Maybe{InstrumentKind}
    maker_commission::Maybe{Float64}
    max_leverage::Maybe{Float64}
    max_liquidation_commission::Maybe{Float64}
    min_trade_amount::Maybe{Float64}
    option_type::Maybe{OptionType}
    price_index::Maybe{String}
    quote_currency::Maybe{String}
    rfq::Bool
    settlement_currency::Maybe{String}
    settlement_period::Maybe{String}
    strike::Maybe{Float64}
    taker_commission::Maybe{Float64}
    tick_size::Maybe{Float64}
end

"""
    instrument(client::DeribitClient, query::InstrumentQuery)
    instrument(client::DeribitClient = Deribit.Common.public_client; kw...)

Retrieves available trading instruments. This method can be used to see which instruments are available for trading, or which instruments have recently expired.

[`GET api/v2/public/get_instruments`](https://docs.deribit.com/#public-get_instruments)

## Parameters:

| Parameter | Type           | Required | Description               |
|:----------|:---------------|:---------|:--------------------------|
| currency  | Currency       | true     | `BTC` `ETH` `USDC` `USDT` |
| expired   | Bool           | false    |                           |
| kind      | InstrumentKind | false    | `option` `spot` `future` `future_combo` `option_combo` |


## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Deribit

result = Deribit.Common.instrument(;
    currency = Deribit.Common.Instrument.BTC
)

to_pretty_json(result.result)
```

## Result:

```json

{
  "id":null,
  "jsonrpc":"2.0",
  "testnet":false,
  "usDiff":1746,
  "usOut":"2024-05-17T11:57:46.222272",
  "usIn":"2024-05-17T11:57:46.220526080",
  "result":[
    {
      "base_currency":"BTC",
      "block_trade_commission":0.0003,
      "block_trade_min_trade_amount":25.0,
      "block_trade_tick_size":0.0001,
      "contract_size":1.0,
      "counter_currency":"USD",
      "creation_timestamp":"2024-05-15T08:00:13",
      "expiration_timestamp":"2024-05-18T08:00:00",
      "future_type":null,
      "instrument_id":326799,
      "instrument_name":"BTC-18MAY24-55000-C",
      "instrument_type":"reversed",
      "is_active":true,
      "kind":"option",
      "maker_commission":0.0003,
      "max_leverage":null,
      "max_liquidation_commission":null,
      "min_trade_amount":0.1,
      "option_type":"call",
      "price_index":"btc_usd",
      "quote_currency":"BTC",
      "rfq":false,
      "settlement_currency":"BTC",
      "settlement_period":"day",
      "strike":55000.0,
      "taker_commission":0.0003,
      "tick_size":0.0001
    },
    ...
  ]
}

```
"""
function instrument(client::DeribitClient, query::InstrumentQuery)
    return APIsRequest{Data{Vector{InstrumentData}}}("GET", "api/v2/public/get_instruments", query)(client)
end

function instrument(client::DeribitClient = Deribit.Common.public_client; kw...)
    return instrument(client, InstrumentQuery(; kw...))
end

end
