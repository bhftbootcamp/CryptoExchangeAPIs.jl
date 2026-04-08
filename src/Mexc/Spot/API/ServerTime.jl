module ServerTime

export ServerTimeQuery,
    ServerTimeData,
    server_time

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct ServerTimeQuery <: MexcPublicQuery
    #__ empty
end

struct ServerTimeData <: MexcData
    serverTime::NanoDate
end

"""
    server_time(client::MexcClient, query::ServerTimeQuery)
    server_time(client::MexcClient = Mexc.Spot.public_client; kw...)

Check current server time.

[`GET api/v3/time`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#check-server-time)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.Spot.server_time()

to_pretty_json(result.result)
```

## Result:

```json
{
  "serverTime": "2024-07-06T11:39:06.032"
}
```
"""
function server_time(client::MexcClient, query::ServerTimeQuery)
    return APIsRequest{ServerTimeData}("GET", "api/v3/time", query)(client)
end

function server_time(client::MexcClient = Mexc.Spot.public_client; kw...)
    return server_time(client, ServerTimeQuery(; kw...))
end

end
