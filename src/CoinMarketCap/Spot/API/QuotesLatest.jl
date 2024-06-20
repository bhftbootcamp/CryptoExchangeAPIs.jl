module QuotesLatest

export QuotesLatestQuery,
    QuotesLatestData,
    quotes_latest


using Serde
using Dates, NanoDates, TimeZones
using CryptoAPIs.CoinMarketCap
using CryptoAPIs: Maybe, APIsRequest
 
Base.@kwdef struct QuotesLatestQuery <: CoinMarketCapPublicQuery
    convert::String
end

struct Quote
    total_market_cap::Float64
    total_volume_24h::Float64
    total_volume_24h_reported::Float64
    altcoin_volume_24h::Float64
    altcoin_volume_24h_reported::Float64
    altcoin_market_cap::Float64
    last_updated::DateTime
end

struct DataEntry
    btc_dominance::Float64
    eth_dominance::Float64
    active_cryptocurrencies::Int
    total_cryptocurrencies::Int
    active_market_pairs::Int
    active_exchanges::Int
    total_exchanges::Int
    last_updated::DateTime
    quote::Dict{String, Quote} # A dictionary to hold quotes in different currencies
end
end

struct Status 
    timestamp::String
    error_code::Int64
    error_message::Maybe{String}
    elapsed::Int64
    credit_count::Int64
    notice::Maybe{String}
end

struct QuotesLatestData 
    data::Dict{String, Any}
    status::Status
end


"""
    quotes_latest(client::CoinMarketCapClient, query::QuotesLatestQuery)
    quotes_latest(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)

 Returns a mapping of all cryptocurrencies to unique CoinMarketCap ids

[`GET /v1/global-metrics/quotes/latest`](https://pro-api.coinmarketcap.com/v1/global-metrics/quotes/latest)

## Parameters:

| Parameter   | Type   | Required | Description |
|:------------|:-------|:---------|:------------|
| convert     | String | true     |             |


## Code samples:

```julia
using Serde
using CryptoAPIs.CoinMarketCap

result = CryptoAPIs.CoinMarketCap.Spot.quotes_latest(convert="BTC")

println(to_pretty_json(result.result))
```

## Result:

```{
  "data":{
    "stablecoin_volume_24h_reported":5.096451737101064e11,
    "defi_24h_percentage_change":28.53995275976,
    "active_exchanges":781,
    "eth_dominance_yesterday":17.57590284,
    "total_exchanges":8709,
    "stablecoin_market_cap":1.5521185843195074e11,
    "btc_dominance":54.540644982162,
    "defi_volume_24h":7.737118887665872e9,
    "stablecoin_volume_24h":9.46977362172208e10,
    "derivatives_volume_24h":7.898552489259844e11,
    "active_market_pairs":82748,
    "eth_dominance_24h_percentage_change":0.51001868379,
    "active_cryptocurrencies":10123,
    "defi_market_cap":7.263525792494272e10,
    "last_updated":"2024-06-18T23:54:59.999Z",
    "btc_dominance_yesterday":54.59215182,
    "derivatives_volume_24h_reported":7.909572821009508e11,
    "quote":{
      "BTC":{
        "altcoin_volume_24h_reported":4.946427075063164e6,
        "total_volume_24h_yesterday":1.2150756996441856e6,
        "altcoin_market_cap":1.6421664681817254e7,
        "stablecoin_volume_24h_reported":7.826666105401059e6,
        "total_market_cap_yesterday_percentage_change":-3.1041601137021485e-5,
        "total_volume_24h":1.5557010236728606e6,
        "defi_24h_percentage_change":0.0004382905841891061,
        "total_market_cap":3.612384002230863e7,
        "stablecoin_market_cap":2.3836022672445583e6,
        "total_market_cap_yesterday":3.68690824167634e7,
        "defi_volume_24h":118819.6205425029,
        "stablecoin_volume_24h":1.454281528683953e6,
        "derivatives_volume_24h":1.2129877067095492e7,
        "total_volume_24h_reported":8.103519950840621e6,
        "defi_market_cap":1.1154660940271737e6,
        "last_updated":"2024-06-18T23:56:00.000Z",
        "altcoin_volume_24h":949971.5455161711,
        "derivatives_volume_24h_reported":1.2146801088242887e7,
        "stablecoin_24h_percentage_change":0.00045292262306325233,
        "derivatives_24h_percentage_change":0.0002717731667481281,
        "total_volume_24h_yesterday_percentage_change":0.000430509250920717,
        "defi_volume_24h_reported":713651.2005510392
      }
    },
    "eth_dominance":18.08592152379,
    "stablecoin_24h_percentage_change":29.492740050456,
    "total_cryptocurrencies":30302,
    "derivatives_24h_percentage_change":17.696919852185,
    "btc_dominance_24h_percentage_change":-0.051506837838,
    "defi_volume_24h_reported":4.647047480692585e10
  },
  "status":{
    "timestamp":"2024-06-18T23:57:02.386Z",
    "error_code":0,
    "error_message":null,
    "elapsed":22,
    "credit_count":1,
    "notice":null
  }
}
```
"""

function quotes_latest(client::CoinMarketCapClient, query::QuotesLatestQuery)
    return APIsRequest{QuotesLatestData}("GET", "/v1/global-metrics/quotes/latest", query)(client)
end

function quotes_latest(client::CoinMarketCapClient = CoinMarketCap.Spot.public_client; kw...)
   return quotes_latest(client, QuotesLatestQuery(; kw...))

end

end