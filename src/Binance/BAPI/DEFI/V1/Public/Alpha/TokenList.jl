module TokenList

export TokenListQuery,
    TokenListData,
    token_list

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Binance
using CryptoExchangeAPIs: Maybe, APIsRequest

struct TokenListQuery <: BinancePublicQuery end

struct Token <: BinanceData
    alphaId::String
    bnExclusiveState::Bool
    canTransfer::Bool
    cexCoinName::Maybe{String}
    cexOffDisplay::Bool
    chainIconUrl::String
    chainId::String
    chainName::String
    circulatingSupply::Float64
    contractAddress::String
    count24h::Maybe{Int}
    decimals::Int
    denomination::Int
    fdv::Maybe{Float64}
    holders::Maybe{Int}
    hotTag::Bool
    iconUrl::String
    liquidity::Maybe{Float64}
    listingCex::Bool
    listingTime::NanoDate
    marketCap::Float64
    mulPoint::Int
    name::String
    offline::Bool
    offsell::Bool
    onlineAirdrop::Bool
    onlineTge::Bool
    percentChange24h::Maybe{Float64}
    price::Float64
    priceHigh24h::Maybe{Float64}
    priceLow24h::Maybe{Float64}
    score::Int
    stockState::Bool
    symbol::String
    tokenId::String
    totalSupply::Maybe{Float64}
    tradeDecimal::Int
    volume24h::Maybe{Float64}
end

Serde.isempty(::Type{Token}, x) = isempty(x)

struct TokenListData <: BinanceData
    code::String
    message::Maybe{String}
    data::Vector{Token}
end

"""
    token_list(client::BinanceClient, query::TokenListQuery)
    token_list(client::BinanceClient = Binance.BinanceClient(Binance.public_bapi_config); kw...)

Retrieves a list of all available ALPHA tokens, including their IDs and symbols.

[`GET dapi/v1/exchangeInfo`](https://developers.binance.com/docs/alpha/market-data/rest-api/token-list)

## Code samples:

```julia
using CryptoExchangeAPIs.Binance

result = Binance.BAPI.DEFI.V1.Public.Alpha.token_list()
```
"""
function token_list(client::BinanceClient, query::TokenListQuery)
    return APIsRequest{TokenListData}(
        "GET",
        "bapi/defi/v1/public/wallet-direct/buw/wallet/cex/alpha/all/token/list",
        query
    )(client)
end

function token_list(
    client::BinanceClient = Binance.BinanceClient(Binance.public_bapi_config)
)
    return token_list(client, TokenListQuery())
end

end

