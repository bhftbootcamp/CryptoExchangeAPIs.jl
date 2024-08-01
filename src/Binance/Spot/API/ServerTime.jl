module ServerTime

export ServerTimeQuery, 
    ServerTimeData, 
    server_time

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ServerTimeQuery <: BinancePublicQuery
    #__ empty
end

struct ServerTimeData <: BinanceData
    serverTime::NanoDate
end

"""
    server_time(client::BinanceClient, query::ServerTimeQuery)
    server_time(client::BinanceClient = Binance.Spot.public_client; kw...)

Check current server time.

[`GET api/v3/time`](https://binance-docs.github.io/apidocs/spot/en/#check-server-time)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Binance

result = Binance.Spot.server_time()

to_pretty_json(result.result)
```

## Result:

```json
{
  "serverTime": "2024-07-06T11:39:06.032"
}
```
"""
function server_time(client::BinanceClient, query::ServerTimeQuery)
    return APIsRequest{ServerTimeData}("GET", "api/v3/time", query)(client)
end

function server_time(client::BinanceClient = Binance.Spot.public_client; kw...)
    return server_time(client, ServerTimeQuery(; kw...))
end

end