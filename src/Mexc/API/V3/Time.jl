module Time

export TimeQuery,
    TimeData,
    time

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Mexc
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct TimeQuery <: MexcPublicQuery
    #__ empty
end

struct TimeData <: MexcData
    serverTime::NanoDate
end

"""
    time(client::MexcClient, query::TimeQuery)
    time(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)

Check current server time.

[`GET api/v3/time`](https://mexcdevelop.github.io/apidocs/spot_v3_en/#check-server-time)

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Mexc

result = Mexc.API.V3.time()

to_pretty_json(result.result)
```

## Result:

```json
{
  "serverTime": "2024-07-06T11:39:06.032"
}
```
"""
function time(client::MexcClient, query::TimeQuery)
    return APIsRequest{TimeData}("GET", "api/v3/time", query)(client)
end

function time(client::MexcClient = MexcSpotClient(Mexc.public_spot_config); kw...)
    return time(client, TimeQuery(; kw...))
end

end
