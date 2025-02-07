module Bithumb

export BithumbCommonQuery,
    BithumbPublicQuery,
    BithumbAccessQuery,
    BithumbPrivateQuery,
    BithumbAPIError,
    BithumbClient,
    BithumbData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle
using UUIDs, JSONWebTokens

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type BithumbData <: AbstractAPIsData end
abstract type BithumbCommonQuery  <: AbstractAPIsQuery end
abstract type BithumbPublicQuery  <: BithumbCommonQuery end
abstract type BithumbAccessQuery  <: BithumbCommonQuery end
abstract type BithumbPrivateQuery <: BithumbCommonQuery end

"""
    Data{D<:Union{A,Vector{A},Dict{String,A}} where {A<:AbstractAPIsData}} <: AbstractAPIsData

## Required fields
- `status::String`: Request status.
- `data::D`: Request result data.

## Optional fields
- `date::NanoDate`: Current time.
"""
struct Data{D<:Union{A,Vector{A},Dict{String,A}} where {A<:AbstractAPIsData}} <: AbstractAPIsData
    status::String
    date::Maybe{NanoDate}
    data::D
end

"""
    BithumbClient <: AbstractAPIsClient

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
Base.@kwdef struct BithumbClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    BithumbAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `status::Int64`: Error status code.

## Optional fields
- `message::String`: Error message.
"""
struct BithumbAPIError{T} <: AbstractAPIsError
    status::Int64
    message::Maybe{String}

    function BithumbAPIError(status::Int64, x...)
        return new{status}(status, x...)
    end
end

function Base.show(io::IO, e::BithumbAPIError)
    return print(io, "status = ", "\"", e.status, "\"", ", ", "message = ", "\"", e.message, "\"")
end

CryptoExchangeAPIs.error_type(::BithumbClient) = BithumbAPIError

function CryptoExchangeAPIs.request_sign!(::BithumbClient, query::Q, ::String)::Q where {Q<:BithumbPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BithumbClient, query::Q, endpoint::String)::Q where {Q<:BithumbPrivateQuery}
    query.signature = nothing
    body = Dict{String,Any}(
        "access_key" => client.public_key,
        "nonce" => string(UUIDs.uuid4()),
        "timestamp" => string(datetime2unix(now(UTC))),
    )
    if !isempty(Serde.to_query(query))
        qstr = Serde.to_query(query)
        merge!(body, Dict{String,Any}(
            "query_hash" => hexdigest("sha512", qstr),
            "query_hash_alg" => "SHA512",
        ))
    end
    hs512 = JSONWebTokens.HS512(client.secret_key)
    token = JSONWebTokens.encode(hs512, body)
    query.signature = "Bearer $token"
    return query
end

function CryptoExchangeAPIs.request_sign!(::BithumbClient, query::Q, ::String)::Q where {Q<:BithumbAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BithumbCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BithumbCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BithumbClient, ::BithumbPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::BithumbClient, query::BithumbPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
       "Authorization" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
