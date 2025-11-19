module AlignedQuoteTokenInfo

export AlignedQuoteTokenInfoQuery,
    AlignedQuoteTokenInfoData,
    aligned_quote_token_info

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Hyperliquid
using CryptoExchangeAPIs: Maybe, APIsRequest

struct AlignedQuoteTokenInfoQuery <: HyperliquidPublicQuery
    type::String
    token::Int
    
    function AlignedQuoteTokenInfoQuery(; token::Int)
        new("alignedQuoteTokenInfo", token)
    end
end

struct AlignedQuoteTokenInfoData <: HyperliquidData
    isAligned::Maybe{Bool}
    firstAlignedTime::Maybe{NanoDate}
    evmMintedSupply::Maybe{String}
    dailyAmountOwed::Maybe{Vector{Vector{String}}}
    predictedRate::Maybe{String}
end

function Serde.isempty(::Type{AlignedQuoteTokenInfoData}, x)::Bool
    return x === nothing
end

# Handle null response from API
function Serde.deser(::Serde.CustomType, ::Type{AlignedQuoteTokenInfoData}, ::Nothing)
    return AlignedQuoteTokenInfoData(nothing, nothing, nothing, nothing, nothing)
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

