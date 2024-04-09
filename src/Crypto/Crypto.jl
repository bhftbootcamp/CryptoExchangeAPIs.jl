module Crypto

export CryptoCommonQuery,
    CryptoPublicQuery,
    CryptoAccessQuery,
    CryptoPrivateQuery,
    CryptoAPIError,
    CryptoClient,
    CryptoData

using Serde
using Dates, NanoDates, Base64, Nettle
using UUIDs, JSONWebTokens

using ..CryptoAPIs
using ..CryptoAPIs: Maybe,  AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type CryptoData <: AbstractAPIsData end
abstract type CryptoCommonQuery <: AbstractAPIsQuery end
abstract type CryptoPublicQuery <: CryptoCommonQuery end
abstract type CryptoAccessQuery <: CryptoCommonQuery end
abstract type CryptoPrivateQuery <: CryptoCommonQuery end

"""
    CryptoClient <: AbstractAPIsClient

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
Base.@kwdef struct CryptoClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

struct CryptoAPIsErrorMsg
    name::Int64
    message::String
end

"""
    CryptoAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields in CryptoAPIsErrorMsg
- `name::Int64`: Error code.
- `message::String`: Error message.

## Required fields
- `error::CryptoAPIsErrorMsg`: Error struct.
"""
struct CryptoAPIError{T} <: AbstractAPIsError
    error::CryptoAPIsErrorMsg

    function CryptoAPIError(error::CryptoAPIsErrorMsg)
        return new{error.name}(error)
    end
end

CryptoAPIs.error_type(::CryptoClient) = CryptoAPIError

function Base.show(io::IO, e::CryptoAPIError)
    return print(io, "name = ", "\"", e.error.name, "\"", ", ", "msg = ", "\"", e.error.message, "\"")
end

struct CryptoUndefError <: AbstractAPIsError
    e::Exception
    msg::String
end

function CryptoAPIs.request_sign!(::CryptoClient, query::Q, ::String)::Q where {Q<:CryptoPublicQuery}
    return query
end

function CryptoAPIs.request_sign!(client::CryptoClient, query::Q, ::String)::Q where {Q<:CryptoPrivateQuery}
    query.signature = nothing
    body = Dict{String,String}(
        "access_key" => client.public_key,
        "nonce" => string(UUIDs.uuid1()),
    )
    qstr = Serde.to_query(query)
    if !isempty(qstr)
        merge!(body, Dict{String,String}(
            "query_hash" => hexdigest("sha512", qstr),
            "query_hash_alg" => "SHA512",
        ))
    end
    hs512 = JSONWebTokens.HS512(client.secret_key)
    token = JSONWebTokens.encode(hs512, body)
    query.signature = "Bearer $token"
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:CryptoCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:CryptoCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::CryptoClient, ::CryptoPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoAPIs.request_headers(client::CryptoClient, query::CryptoPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Authorization" => query.signature,
    ]
end

include("Spot/Spot.jl")
using .Spot

end
