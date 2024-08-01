module Binance

export BinanceCommonQuery,
    BinancePublicQuery,
    BinanceAccessQuery,
    BinancePrivateQuery,
    BinanceAPIError,
    BinanceClient,
    BinanceData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type BinanceData <: AbstractAPIsData end
abstract type BinanceCommonQuery  <: AbstractAPIsQuery end
abstract type BinancePublicQuery  <: BinanceCommonQuery end
abstract type BinanceAccessQuery  <: BinanceCommonQuery end
abstract type BinancePrivateQuery <: BinanceCommonQuery end

"""
    BinanceClient <: AbstractAPIsClient

Client info.

## Required fields
- `base_url::String`: Base URL for the client. 

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `interface::String`: Interface for the client.
- `proxy::String`: Proxy information for the client.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
"""
Base.@kwdef struct BinanceClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    BinanceAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.

## Optional fields
- `type::String`: Type of error.
- `msg::String`: Error message.
"""
struct BinanceAPIError{T} <: AbstractAPIsError
    code::Int64
    type::Maybe{String}
    msg::Maybe{String}

    function BinanceAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::BinanceClient) = BinanceAPIError

function Base.show(io::IO, e::BinanceAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::BinanceClient, query::Q, ::String)::Q where {Q<:BinancePublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BinanceClient, query::Q, ::String)::Q where {Q<:BinancePrivateQuery}
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    str_query = Serde.to_query(query)
    query.signature = hexdigest("sha256", client.secret_key, str_query)
    return query
end

function CryptoExchangeAPIs.request_sign!(::BinanceClient, query::Q, ::String)::Q where {Q<:BinanceAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BinanceCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BinanceCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinancePublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinancePrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MBX-APIKEY" => client.public_key,
    ]
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinanceAccessQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MBX-APIKEY" => client.public_key,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("CoinMFutures/CoinMFutures.jl")
using .CoinMFutures

include("USDMFutures/USDMFutures.jl")
using .USDMFutures

include("Spot/Spot.jl")
using .Spot

end
