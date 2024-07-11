module Aevo

export AevoCommonQuery,
    AevoPublicQuery,
    AevoAccessQuery,
    AevoAPIError,
    AevoClient,
    AevoData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoAPIs
import ..CryptoAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type AevoData <: AbstractAPIsData end
abstract type AevoCommonQuery  <: AbstractAPIsQuery end
abstract type AevoPublicQuery  <: AevoCommonQuery end
abstract type AevoAccessQuery  <: AevoCommonQuery end

"""
AevoClient <: AbstractAPIsClient

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
Base.@kwdef struct AevoClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    AevoAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.

## Optional fields
- `type::String`: Type of error.
- `msg::String`: Error message.
"""
struct AevoAPIError{T} <: AbstractAPIsError
    error::String

    function AevoAPIError(error::String, x...)
        return new{Symbol(error)}(error, x...)
    end
end

CryptoAPIs.error_type(::AevoClient) = AevoAPIError

function Base.show(io::IO, e::AevoAPIError)
    return print(io, "error = ", "\"", e.error)
end

function CryptoAPIs.request_sign!(::AevoClient, query::Q, ::String)::Q where {Q<:AevoCommonQuery}
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:AevoCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:AevoCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::AevoClient, ::AevoCommonQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "accept" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Derivatives/Derivatives.jl")
using .Derivatives

end
