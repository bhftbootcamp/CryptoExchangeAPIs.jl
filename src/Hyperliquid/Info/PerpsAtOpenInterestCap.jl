module PerpsAtOpenInterestCap

export PerpsAtOpenInterestCapQuery,
    PerpsAtOpenInterestCapData,
    perps_at_open_interest_cap

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct PerpsAtOpenInterestCapQuery <: HyperliquidPublicQuery
    type::String
    
    function PerpsAtOpenInterestCapQuery()
        new("perpsAtOpenInterestCap")
    end
end

const PerpsAtOpenInterestCapData = Vector{String}

"""
    perps_at_open_interest_cap(client::HyperliquidClient, query::PerpsAtOpenInterestCapQuery)
    perps_at_open_interest_cap(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query perps at open interest caps.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals#query-perps-at-open-interest-caps)

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.perps_at_open_interest_cap()
```
"""
function perps_at_open_interest_cap(client::HyperliquidClient, query::PerpsAtOpenInterestCapQuery)
    return APIsRequest{PerpsAtOpenInterestCapData}("POST", "info", query)(client)
end

function perps_at_open_interest_cap(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return perps_at_open_interest_cap(client, PerpsAtOpenInterestCapQuery(; kw...))
end

end

