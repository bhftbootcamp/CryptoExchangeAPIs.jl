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
    count24h::Int64
    decimals::Int64
    denomination::Int64
    fdv::Float64
    holders::Int64
    hotTag::Bool
    iconUrl::String
    liquidity::Float64
    listingCex::Bool
    listingTime::NanoDate
    marketCap::Float64
    mulPoint::Int64
    name::String
    offline::Bool
    offsell::Bool
    onlineAirdrop::Bool
    onlineTge::Bool
    percentChange24h::Float64
    price::Float64
    priceHigh24h::Float64
    priceLow24h::Float64
    score::Int64
    stockState::Bool
    symbol::String
    tokenId::String
    totalSupply::Float64
    tradeDecimal::Int64
    volume24h::Float64
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

