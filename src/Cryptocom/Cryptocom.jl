module Cryptocom

export CryptocomCommonQuery,
    CryptocomPublicQuery,
    CryptocomAccessQuery,
    CryptocomPrivateQuery,
    CryptocomAPIError,
    CryptocomClient,
    CryptocomData

using Serde
using Dates, NanoDates, Base64, Nettle

using ..CryptoAPIs
using ..CryptoAPIs: Maybe,  AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type CryptocomData <: AbstractAPIsData end
abstract type CryptocomCommonQuery <: AbstractAPIsQuery end
abstract type CryptocomPublicQuery <: CryptocomCommonQuery end
abstract type CryptocomAccessQuery <: CryptocomCommonQuery end
abstract type CryptocomPrivateQuery <: CryptocomCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `id::Int64`: Return id.
- `method::String`: Return method endpoint.
- `code::String`: Return code.
- `result::D`: Request result data.
"""
struct Data{D<:AbstractAPIsData} <: AbstractAPIsData
    id::Int64
    method::String
    code::String
    result::D
end

"""
    CryptocomClient <: AbstractAPIsClient

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
Base.@kwdef struct CryptocomClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

struct CryptocomAPIsErrorMsg
    id::Maybe{Int64}
    code::Int64
    message::String
end

"""
    CryptocomAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields in CryptocomAPIsErrorMsg
- `code::Int64`: Error code.
- `message::String`: Error message.

## Required fields
- `error::CryptocomAPIsErrorMsg`: Error struct.
"""
struct CryptocomAPIError{T} <: AbstractAPIsError
    error::CryptocomAPIsErrorMsg

    function CryptocomAPIError(error::CryptocomAPIsErrorMsg)
        return new{error.code}(error)
    end
end

CryptoAPIs.error_type(::CryptocomClient) = CryptocomAPIError

function Base.show(io::IO, e::CryptocomAPIError)
    return print(io, "id = ", "\"", e.error.id, "\"", "code = ", "\"", e.error.code, "\"", ", ", "msg = ", "\"", e.error.message, "\"")
end

struct CryptocomUndefError <: AbstractAPIsError
    e::Exception
    msg::String
end

function CryptoAPIs.request_sign!(::CryptocomClient, query::Q, ::String)::Q where {Q<:CryptocomPublicQuery}
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:CryptocomCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:CryptocomCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::CryptocomClient, ::CryptocomPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

include("Utils.jl")

include("Spot/Spot.jl")
using .Spot

end
