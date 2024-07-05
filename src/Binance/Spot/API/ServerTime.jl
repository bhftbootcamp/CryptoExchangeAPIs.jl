module ServerTime

export ServerTimeQuery, ServerTimeData, server_time

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

struct ServerTimeQuery <: BinancePublicQuery end

struct ServerTimeData <: BinanceData
    serverTime::Int64
end

"""
    server_time(client::BinanceClient)
    server_time(client::BinanceClient = Binance.Spot.public_client)

Check Server Time.

[`GET api/v3/time`](https://binance-docs.github.io/apidocs/spot/en/#check-server-time)

Test connectivity to the Rest API and get the current server time.

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

result = Binance.Spot.server_time()

to_pretty_json(result.result)
```

## Result:

```json
{
  "serverTime": 1499827319559
}
```
"""
function server_time(client::BinanceClient)
    return APIsRequest{ServerTimeData}("GET", "api/v3/time", ServerTimeQuery())(client)
end
    
function server_time(; client::BinanceClient = Binance.Spot.public_client)
    return server_time(client)
end
    
end
