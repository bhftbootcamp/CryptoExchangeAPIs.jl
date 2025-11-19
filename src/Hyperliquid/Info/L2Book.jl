module L2Book

export L2BookQuery,
    L2BookData,
    l2_book

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct L2BookQuery <: HyperliquidPublicQuery
    type::String
    coin::String
    nSigFigs::Maybe{Int}
    mantissa::Maybe{Int}
    
    function L2BookQuery(; coin::String, nSigFigs::Maybe{Int} = nothing, mantissa::Maybe{Int} = nothing)
        new("l2Book", coin, nSigFigs, mantissa)
    end
end

struct BookLevel <: HyperliquidData
    px::String
    sz::String
    n::Int
end

struct L2BookData <: HyperliquidData
    coin::String
    time::NanoDate
    levels::Vector{Vector{BookLevel}}
end

"""
    l2_book(client::HyperliquidClient, query::L2BookQuery)
    l2_book(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

L2 book snapshot. Returns at most 20 levels per side.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#l2-book-snapshot)

## Parameters:

| Parameter | Type   | Required | Description                                                                       |
|:----------|:-------|:---------|:----------------------------------------------------------------------------------|
| coin      | String | true     | Coin name                                                                         |
| nSigFigs  | Int    | false    | Aggregate levels to nSigFigs significant figures. Valid: 2, 3, 4, 5, null         |
| mantissa  | Int    | false    | Aggregate levels. Only allowed if nSigFigs is 5. Valid: 1, 2, 5                   |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.l2_book(;
    coin = "BTC"
)

result = Hyperliquid.Info.l2_book(;
    coin = "ETH",
    nSigFigs = 5
)
```
"""
function l2_book(client::HyperliquidClient, query::L2BookQuery)
    return APIsRequest{L2BookData}("POST", "info", query)(client)
end

function l2_book(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return l2_book(client, L2BookQuery(; kw...))
end

end

