module Upbit

export UpbitCommonQuery,
    UpbitPublicQuery,
    UpbitAccessQuery,
    UpbitPrivateQuery,
    UpbitAPIError,
    UpbitClient,
    UpbitData

using Serde
using Dates, NanoDates, Base64, Nettle
using UUIDs, JSONWebTokens

using ..CryptoAPIs
using ..CryptoAPIs: Maybe,  AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type UpbitData <: AbstractAPIsData end
abstract type UpbitCommonQuery <: AbstractAPIsQuery end
abstract type UpbitPublicQuery <: UpbitCommonQuery end
abstract type UpbitAccessQuery <: UpbitCommonQuery end
abstract type UpbitPrivateQuery <: UpbitCommonQuery end

"""
    UpbitClient <: AbstractAPIsClient

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
Base.@kwdef struct UpbitClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

struct UpbitAPIsErrorMsg
    name::Int64
    message::String
end

"""
    UpbitAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields in UpbitAPIsErrorMsg
- `name::Int64`: Error code.
- `message::String`: Error message.

## Required fields
- `error::UpbitAPIsErrorMsg`: Error struct.
"""
struct UpbitAPIError{T} <: AbstractAPIsError
    error::UpbitAPIsErrorMsg

    function UpbitAPIError(error::UpbitAPIsErrorMsg)
        return new{error.name}(error)
    end
end

CryptoAPIs.error_type(::UpbitClient) = UpbitAPIError

function Base.show(io::IO, e::UpbitAPIError)
    return print(io, "name = ", "\"", e.error.name, "\"", ", ", "msg = ", "\"", e.error.message, "\"")
end

struct UpbitUndefError <: AbstractAPIsError
    e::Exception
    msg::String
end

function CryptoAPIs.request_sign!(::UpbitClient, query::Q, ::String)::Q where {Q<:UpbitPublicQuery}
    return query
end

function CryptoAPIs.request_sign!(client::UpbitClient, query::Q, ::String)::Q where {Q<:UpbitPrivateQuery}
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

function CryptoAPIs.request_body(::Q)::String where {Q<:UpbitCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:UpbitCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::UpbitClient, ::UpbitPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoAPIs.request_headers(client::UpbitClient, query::UpbitPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Authorization" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
