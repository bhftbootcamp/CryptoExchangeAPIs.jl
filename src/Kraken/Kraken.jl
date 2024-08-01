module Kraken

export KrakenCommonQuery,
    KrakenPublicQuery,
    KrakenAccessQuery,
    KrakenPrivateQuery,
    KrakenAPIError,
    KrakenClient,
    KrakenData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type KrakenData <: AbstractAPIsData end
abstract type KrakenCommonQuery  <: AbstractAPIsQuery end
abstract type KrakenPublicQuery  <: KrakenCommonQuery end
abstract type KrakenAccessQuery  <: KrakenCommonQuery end
abstract type KrakenPrivateQuery <: KrakenCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `error::Vector{Any}`: Error values.
- `result::D`: Request result data.
"""
struct Data{D} <: AbstractAPIsData
    error::Vector{Any}
    result::D
end

"""
    KrakenClient <: AbstractAPIsClient

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
Base.@kwdef struct KrakenClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    KrakenAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `error::Vector{String}`: Error values.
"""
struct KrakenAPIError{T} <: AbstractAPIsError
    error::Vector{String}

    function KrakenAPIError(error::Vector{String})
        return new{Symbol(error[1])}(error)
    end
end

function Base.show(io::IO, e::KrakenAPIError)
    return print(io, "error = ", "\"", e.error, "\"")
end

CryptoExchangeAPIs.error_type(::KrakenClient) = KrakenAPIError

function CryptoExchangeAPIs.request_sign!(::KrakenClient, query::Q, ::String)::Q where {Q<:KrakenPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::KrakenClient, query::Q, endpoint::String)::Q where {Q<:KrakenPrivateQuery}
    query.nonce = Dates.now(UTC)
    body::String = Serde.to_query(query)
    encoded = Vector{UInt8}(string(round(Int64, 1000 * datetime2unix(query.nonce)), body))
    bdigest = digest("sha256", encoded)
    salt = [Vector{UInt8}("/" * endpoint); bdigest]
    query.signature = base64encode(digest("sha512", base64decode(client.secret_key), salt))
    return query
end

function CryptoExchangeAPIs.request_sign!(::KrakenClient, query::Q, ::String)::Q where {Q<:KrakenAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:KrakenPublicQuery}
    return ""
end

function CryptoExchangeAPIs.request_body(query::Q)::String where {Q<:KrakenPrivateQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:KrakenPublicQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(::Q)::String where {Q<:KrakenPrivateQuery}
    return ""
end

function CryptoExchangeAPIs.request_headers(::KrakenClient, ::KrakenPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::KrakenClient, query::KrakenPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/x-www-form-urlencoded",
        "API-Key"  => client.public_key,
        "API-Sign" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
