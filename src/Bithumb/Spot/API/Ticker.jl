module Ticker

export TikerQuery,
    TikerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bithumb
using CryptoAPIs.Bithumb: Data
using CryptoAPIs: Maybe, APIsRequest
import CryptoAPIs: prepare_json!

Base.@kwdef struct TickerQuery <: BithumbPublicQuery
    payment_currency::String
    order_currency::Maybe{String} = "ALL"
end

Serde.SerQuery.ser_ignore_field(::Type{TickerQuery}, ::Val{:order_currency}) = true
Serde.SerQuery.ser_ignore_field(::Type{TickerQuery}, ::Val{:payment_currency}) = true

struct TickerData <: BithumbData
    acc_trade_value::Maybe{Float64}
    acc_trade_value_24H::Maybe{Float64}
    closing_price::Maybe{Float64}
    date::NanoDate
    fluctate_24H::Maybe{Float64}
    fluctate_rate_24H::Maybe{Float64}
    max_price::Maybe{Float64}
    min_price::Maybe{Float64}
    opening_price::Maybe{Float64}
    prev_closing_price::Maybe{Float64}
    units_traded::Maybe{Float64}
    units_traded_24H::Maybe{Float64}
end

function prepare_json!(::Type{T}, json::Dict{String,Any}) where {T<:Data{Dict{String,TickerData}}}
    for (_, item) in json["data"]
        if item isa AbstractDict
            item["date"] = json["data"]["date"]
        end
    end
    delete!(json["data"], "date")
    return json
end

"""
    ticker(client::BithumbClient, query::TikerQuery)
    ticker(client::BithumbClient = Bithumb.Spot.public_client; kw...)

Provides information on the current price of virtual assets at the time of request.

[`GET /public/ticker/{order_currency}_{payment_currency}`](https://apidocs.bithumb.com/reference/현재가-정보-조회)

## Parameters:

| Parameter        | Type   | Required | Description    |
|:-----------------|:-------|:---------|:---------------|
| payment_currency | String | true     |                |
| order_currency   | String | false    | Default: "ALL" |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bithumb

result = Bithumb.Spot.ticker(;
    order_currency = "BTC",
    payment_currency = "KRW",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"0000",
  "date":null,
  "data":{
    "acc_trade_value":1.873153488545703e10,
    "acc_trade_value_24H":7.510337464461333e10,
    "closing_price":8.6533e7,
    "date":"2024-05-14T22:41:49.334000128",
    "fluctate_24H":-1.097e6,
    "fluctate_rate_24H":-1.25,
    "max_price":8.6845e7,
    "min_price":8.575e7,
    "opening_price":8.6639e7,
    "prev_closing_price":8.6659e7,
    "units_traded":217.39853891,
    "units_traded_24H":866.46583706
  }
}
```
"""
function ticker(client::BithumbClient, query::TickerQuery)
    T = query.order_currency == "ALL" ? Dict{String,TickerData} : TickerData
    return APIsRequest{Data{T}}("GET", "public/ticker/$(query.order_currency)_$(query.payment_currency)", query)(client)
end

function ticker(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
