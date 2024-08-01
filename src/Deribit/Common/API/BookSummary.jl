module BookSummary

export BookSummaryQuery,
    BookSummaryData,
    book_summary

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Deribit
using CryptoExchangeAPIs.Deribit: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum Currency begin
    BTC
    ETH
    USDC
    USDT
end

@enum InstrumentKind begin
    future
    option
    future_combo
    option_combo
    spot
end

Base.@kwdef struct BookSummaryQuery <: DeribitPublicQuery
    currency::Currency
    kind::Maybe{InstrumentKind} = nothing
end

struct BookSummaryData <: DeribitData
    instrument_name::String
    base_currency::String
    quote_currency::String
    ask_price::Maybe{Float64}
    bid_price::Maybe{Float64}
    mid_price::Maybe{Float64}
    mark_price::Maybe{Float64}
    estimated_delivery_price::Maybe{Float64}
    price_change::Maybe{Float64}
    volume::Maybe{Float64}
    volume_notional::Maybe{Float64}
    volume_usd::Maybe{Float64}
    high::Maybe{Float64}
    low::Maybe{Float64}
    last::Maybe{Float64}
    current_funding::Maybe{Float64}
    funding_8h::Maybe{Float64}
    interest_rate::Maybe{Float64}
    open_interest::Maybe{Float64}
    underlying_index::Maybe{String}
    underlying_price::Maybe{Float64}
    creation_timestamp::NanoDate
end

"""
    book_summary(client::DeribitClient, query::BookSummaryQuery)
    book_summary(client::DeribitClient = Deribit.Common.public_client; kw...)

Retrieves the summary information such as open interest, 24h volume, etc. for all instruments for the currency (optionally filtered by kind).

[`GET api/v2/public/get_book_summary_by_currency`](https://docs.deribit.com/#public-get_book_summary_by_currency)

## Parameters:

| Parameter | Type           | Required | Description               |
|:----------|:---------------|:---------|:--------------------------|
| currency  | Currency       | true     | `BTC` `ETH` `USDC` `USDT` |
| kind      | InstrumentKind | false    | `option` `spot` `future` `future_combo` `option_combo` |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Deribit

result = Deribit.Common.book_summary(;
    currency = CryptoExchangeAPIs.Deribit.Common.BookSummary.BTC
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
      "instrument_name":"BTC-31MAY24-59000-P",
      "base_currency":"BTC",
      "quote_currency":"BTC",
      "ask_price":0.0065,
      "bid_price":0.006,
      "mid_price":0.00625,
      "mark_price":0.00616094,
      "estimated_delivery_price":66227.07,
      "price_change":-23.5294,
      "volume":196.0,
      "volume_notional":null,
      "volume_usd":98503.18,
      "high":0.0105,
      "low":0.006,
      "last":0.0065,
      "current_funding":null,
      "funding_8h":null,
      "interest_rate":0.0,
      "open_interest":569.7,
      "underlying_index":"BTC-31MAY24",
      "underlying_price":66481.53,
      "creation_timestamp":"2024-05-17T12:00:15.647000064"
    },
    ...
  ]
}
```
"""
function book_summary(client::DeribitClient, query::BookSummaryQuery)
    return APIsRequest{Data{Vector{BookSummaryData}}}("GET", "api/v2/public/get_book_summary_by_currency", query)(client)
end

function book_summary(client::DeribitClient = Deribit.Common.public_client; kw...)
    return book_summary(client, BookSummaryQuery(; kw...))
end

end
