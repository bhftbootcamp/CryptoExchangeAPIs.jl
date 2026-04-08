module Ticker

export TickerQuery,
    TickerData,
    ticker

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TickerQuery <: MexcPublicQuery
    symbol::Maybe{String} = nothing
end

struct TickerData <: MexcData
    symbol::String
    priceChange::Maybe{String}
    priceChangePercent::Maybe{String}
    prevClosePrice::Maybe{String}
    lastPrice::Maybe{String}
    bidPrice::Maybe{String}
    bidQty::Maybe{String}
    askPrice::Maybe{String}
    askQty::Maybe{String}
    openPrice::Maybe{String}
    highPrice::Maybe{String}
    lowPrice::Maybe{String}
    volume::Maybe{String}
    quoteVolume::Maybe{String}
    openTime::Maybe{NanoDate}
    closeTime::Maybe{NanoDate}
    count::Maybe{Int64}
end

"""
    ticker(client::MexcClient, query::TickerQuery)
    ticker(client::MexcClient = Mexc.Spot.public_client; kw...)

24 hour rolling window price change statistics.

[`GET api/v3/ticker/24hr`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#24hr-ticker-price-change-statistics)

## Parameters:

| Parameter | Type   | Required | Description                                                     |
|:----------|:-------|:---------|:----------------------------------------------------------------|
| symbol    | String | false    | If not sent, tickers for all symbols will be returned in array  |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.Spot.ticker(;
    symbol = "BTCUSDT",
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "symbol":"BTCUSDT",
  "priceChange":"184.34",
  "priceChangePercent":"0.00400048",
  "prevClosePrice":"46079.37",
  "lastPrice":"46263.71",
  "bidPrice":"46260.38",
  "bidQty":"",
  "askPrice":"46260.41",
  "askQty":"",
  "openPrice":"46079.37",
  "highPrice":"47550.01",
  "lowPrice":"45555.5",
  "volume":"1732.461487",
  "quoteVolume":null,
  "openTime":"2024-01-05T09:25:00",
  "closeTime":"2024-01-05T09:25:02.808000000",
  "count":null
}
```
"""
function ticker(client::MexcClient, query::TickerQuery)
    return if isnothing(query.symbol)
        APIsRequest{Vector{TickerData}}("GET", "api/v3/ticker/24hr", query)(client)
    else
        APIsRequest{TickerData}("GET", "api/v3/ticker/24hr", query)(client)
    end
end

function ticker(client::MexcClient = Mexc.Spot.public_client; kw...)
    return ticker(client, TickerQuery(; kw...))
end

end
