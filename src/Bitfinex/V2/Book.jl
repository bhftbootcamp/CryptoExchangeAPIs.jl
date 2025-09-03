module Book

export BookQuery,
    BookData,
    book

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bitfinex
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx Precision P0 P1 P2 P3 P4 R0

@enumx BookLength begin
    ONE = 1
    TWENTY_FIVE = 25
    ONE_HUNDRED = 100
end

Base.@kwdef struct BookQuery <: BitfinexPublicQuery
    symbol::String
    precision::Precision.T
    len::BookLength.T = BookLength.ONE
end

function Serde.ser_type(::Type{BookQuery}, x::BookLength.T)::Int64
    return Int64(x)
end

Serde.SerQuery.ser_ignore_field(::Type{BookQuery}, ::Val{:symbol}) = true
Serde.SerQuery.ser_ignore_field(::Type{BookQuery}, ::Val{:precision}) = true

struct BookData <: BitfinexData
    price::Float64
    count::Int64
    amount::Float64
end

"""
    book(client::BitfinexClient, query::BookQuery)
    book(client::BitfinexClient = Bitfinex.public_client; kw...)

The Public Books endpoint allows you to keep track of the state of Bitfinex order books on a price aggregated basis with customizable precision.
Raw books can be retrieved by using precision `R0`.

[`GET v2/book/{symbol}/{precision}`](https://docs.bitfinex.com/reference/rest-public-book)

## Parameters:

| Parameter | Type            | Required | Description |
|:----------|:----------------|:---------|:------------|
| symbol    | String          | true     |             |
| precision | Precision       | true     | `P0` `P1` `P2` `P3` `P4` `R0` |
| len       | BookLength      | false    | Default: `ONE` (1), Available: `TWENTY_FIVE` (25), `ONE_HUNDRED` (100). |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Bitfinex

result = Bitfinex.V2.book(;
    symbol = "tBTCUSD",
    precision = Bitfinex.V2.Book.Precision.P1,
    len = Bitfinex.V2.Book.BookLength.TWENTY_FIVE,
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "price":67070.0,
    "count":4,
    "amount":0.16776825
  },
  ...
]
```
"""
function book(client::BitfinexClient, query::BookQuery)
    return APIsRequest{Vector{BookData}}("GET", "v2/book/$(query.symbol)/$(query.precision)", query)(client)
end

function book(client::BitfinexClient = Bitfinex.public_client; kw...)
    return book(client, BookQuery(; kw...))
end

end
