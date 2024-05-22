module Bitfinex

export BitfinexCommonQuery,
    BitfinexPublicQuery,
    BitfinexAccessQuery,
    BitfinexPrivateQuery,
    BitfinexAPIError,
    BitfinexClient,
    BitfinexData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoAPIs
import ..CryptoAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type BitfinexData <: AbstractAPIsData end
abstract type BitfinexCommonQuery  <: AbstractAPIsQuery end
abstract type BitfinexPublicQuery  <: BitfinexCommonQuery end
abstract type BitfinexAccessQuery  <: BitfinexCommonQuery end
abstract type BitfinexPrivateQuery <: BitfinexCommonQuery end

"""
    BitfinexClient <: AbstractAPIsClient

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
Base.@kwdef struct BitfinexClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    BitfinexAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Optional fields
- `type::String`: Error type.
- `code::Int64`: Error code.
- `msg::String`: Error message.
"""
struct BitfinexAPIError{T} <: AbstractAPIsError
    type::Maybe{String}
    code::Maybe{Int64}
    msg::Maybe{String}

    function BitfinexAPIError(error::String, code::Int64, x...)
        return new{code}(error, code, x...)
    end
end

function Base.show(io::IO, e::BitfinexAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

CryptoAPIs.error_type(::BitfinexClient) = BitfinexAPIError

function CryptoAPIs.request_sign!(::BitfinexClient, query::Q, ::String)::Q where {Q<:BitfinexPublicQuery}
    return query
end

function CryptoAPIs.request_sign!(client::BitfinexClient, query::Q, endpoint::String)::Nothing where {Q<:BitfinexPrivateQuery}
    query.nonce = string(round(Int64, 1000 * datetime2unix(now(UTC))))   
    signature_payload = string("/api/", endpoint, query.nonce)
    query.signature = hexdigest("sha384", client.secret_key, signature_payload)
    return nothing
end

function CryptoAPIs.request_body(::Q)::String where {Q<:BitfinexCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:BitfinexCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::BitfinexClient, ::BitfinexPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoAPIs.request_headers(client::BitfinexClient, query::BitfinexPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "bfx-signature" => query.signature,
        "bfx-apikey" => client.public_key,
        "bfx-nonce" => query.nonce,
        "Content-type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
