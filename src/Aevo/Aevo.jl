module Aevo

export AevoCommonQuery,
    AevoPublicQuery,
    AevoAccessQuery,
    AevoAPIError,
    AevoClient,
    AevoData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

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
    public_client = AevoClient(; base_url = "https://api.aevo.xyz")
"""
const public_client = AevoClient(; base_url = "https://api.aevo.xyz")

"""
    AevoAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `error::String`: Error message.
"""
struct AevoAPIError{T} <: AbstractAPIsError
    error::String

    function AevoAPIError(error::String, x...)
        return new{Symbol(error)}(error, x...)
    end
end

CryptoExchangeAPIs.error_type(::AevoClient) = AevoAPIError

function Base.show(io::IO, e::AevoAPIError)
    return print(io, "error = ", "\"", e.error)
end

function CryptoExchangeAPIs.request_sign!(::AevoClient, query::Q, ::String)::Q where {Q<:AevoCommonQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:AevoCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:AevoCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::AevoClient, ::AevoCommonQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "accept" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("FundingHistory.jl")
using .FundingHistory

include("Statistics.jl")
using .Statistics

end
