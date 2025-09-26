module GetInstruments

export GetInstrumentsQuery,
    GetInstrumentsData,
    get_instruments

export Currency,
    InstrumentKind

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Currency BTC ETH USDC USDT

@enumx InstrumentKind begin
    future
    option
    future_combo
    option_combo
    spot
end

Base.@kwdef struct GetInstrumentsQuery <: DeribitPublicQuery
    currency::Currency.T
    expired::Maybe{Bool} = nothing
    kind::Maybe{InstrumentKind.T} = nothing
end

@enum FutureType linear reversed

@enum OptionType put call

struct GetInstrumentsData <: DeribitData
    instrument_name::Maybe{String}
    base_currency::Maybe{String}
    quote_currency::Maybe{String}
    block_trade_commission::Maybe{Float64}
    block_trade_min_trade_amount::Maybe{Float64}
    block_trade_tick_size::Maybe{Float64}
    contract_size::Maybe{Float64}
    counter_currency::Maybe{String}
    creation_timestamp::NanoDate
    expiration_timestamp::NanoDate
    future_type::Maybe{FutureType}
    instrument_id::Int64
    instrument_type::Maybe{String}
    is_active::Bool
    kind::Maybe{InstrumentKind.T}
    maker_commission::Maybe{Float64}
    max_leverage::Maybe{Float64}
    max_liquidation_commission::Maybe{Float64}
    min_trade_amount::Maybe{Float64}
    option_type::Maybe{OptionType}
    price_index::Maybe{String}
    rfq::Bool
    settlement_currency::Maybe{String}
    settlement_period::Maybe{String}
    strike::Maybe{Float64}
    taker_commission::Maybe{Float64}
    tick_size::Maybe{Float64}
end

"""
    get_instruments(client::DeribitClient, query::InstrumentQuery)
    get_instruments(client::DeribitClient = Deribit.Common.public_client; kw...)

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

result = Deribit.Common.get_instruments(;
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
      "instrument_name":"BTC-18MAY24-55000-C",
      "base_currency":"BTC",
      "quote_currency":"BTC",
      "block_trade_commission":0.0003,
      "block_trade_min_trade_amount":25.0,
      "block_trade_tick_size":0.0001,
      "contract_size":1.0,
      "counter_currency":"USD",
      "creation_timestamp":"2024-05-15T08:00:13",
      "expiration_timestamp":"2024-05-18T08:00:00",
      "future_type":null,
      "instrument_id":326799,
      "instrument_type":"reversed",
      "is_active":true,
      "kind":"option",
      "maker_commission":0.0003,
      "max_leverage":null,
      "max_liquidation_commission":null,
      "min_trade_amount":0.1,
      "option_type":"call",
      "price_index":"btc_usd",
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
function get_instruments(client::DeribitClient, query::GetInstrumentsQuery)
    return APIsRequest{Data{Vector{GetInstrumentsData}}}("GET", "api/v2/public/get_instruments", query)(client)
end

function get_instruments(client::DeribitClient = Deribit.public_client; kw...)
    return get_instruments(client, GetInstrumentsQuery(; kw...))
end

end
