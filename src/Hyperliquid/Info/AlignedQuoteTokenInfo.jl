module AlignedQuoteTokenInfo

export AlignedQuoteTokenInfoQuery,
    AlignedQuoteTokenInfoData,
    aligned_quote_token_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct AlignedQuoteTokenInfoQuery <: HyperliquidPublicQuery
    type::String = "alignedQuoteTokenInfo"
    token::Int
end

struct AlignedQuoteTokenInfoData <: HyperliquidData
    isAligned::Bool
    firstAlignedTime::NanoDate
    evmMintedSupply::String
    dailyAmountOwed::Vector{Tuple{String,String}}
    predictedRate::String
end

"""
    aligned_quote_token_info(client::HyperliquidClient, query::AlignedQuoteTokenInfoQuery)
    aligned_quote_token_info(client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config); kw...)

Query aligned quote token status.

[`POST /info`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint#query-aligned-quote-token-status)

## Parameters:

| Parameter | Type | Required | Description  |
|:----------|:-----|:---------|:-------------|
| token     | Int  | true     | Token index  |

## Code samples:

```julia
using CryptoExchangeAPIs.Hyperliquid

result = Hyperliquid.Info.aligned_quote_token_info(;
    token = 0
)
```
"""
function aligned_quote_token_info(client::HyperliquidClient, query::AlignedQuoteTokenInfoQuery)
    return APIsRequest{AlignedQuoteTokenInfoData}("POST", "info", query)(client)
end

function aligned_quote_token_info(
    client::HyperliquidClient = Hyperliquid.HyperliquidClient(Hyperliquid.public_config);
    kw...,
)
    return aligned_quote_token_info(client, AlignedQuoteTokenInfoQuery(; kw...))
end

end

