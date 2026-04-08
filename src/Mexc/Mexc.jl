module Mexc

export MexcCommonQuery,
    MexcPublicQuery,
    MexcAccessQuery,
    MexcPrivateQuery,
    MexcAPIError,
    MexcClient,
    MexcData,
    Data

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type MexcData <: AbstractAPIsData end
abstract type MexcCommonQuery  <: AbstractAPIsQuery end
abstract type MexcPublicQuery  <: MexcCommonQuery end
abstract type MexcAccessQuery  <: MexcCommonQuery end
abstract type MexcPrivateQuery <: MexcCommonQuery end

"""
    MexcClient <: AbstractAPIsClient

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
Base.@kwdef struct MexcClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    Data{D} <: AbstractAPIsData

Contract API response wrapper.

## Required fields
- `success::Bool`: Request success flag.
- `code::Int64`: Response code (0 = success).
- `data::D`: Actual response data.
"""
struct Data{D} <: AbstractAPIsData
    success::Bool
    code::Int64
    data::D
end

"""
    MexcAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.

## Optional fields
- `msg::String`: Error message (Spot API).
- `message::String`: Error message (Contract API).
"""
struct MexcAPIError{T} <: AbstractAPIsError
    code::Int64
    msg::Maybe{String}
    message::Maybe{String}

    function MexcAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::MexcClient) = MexcAPIError

function Base.show(io::IO, e::MexcAPIError)
    m = something(e.msg, e.message, "")
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", m, "\"")
end

function CryptoExchangeAPIs.request_sign!(::MexcClient, query::Q, ::String)::Q where {Q<:MexcPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::MexcClient, query::Q, ::String)::Q where {Q<:MexcPrivateQuery}
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    str_query = Serde.to_query(query)
    query.signature = hexdigest("sha256", client.secret_key, str_query)
    return query
end

function CryptoExchangeAPIs.request_sign!(::MexcClient, query::Q, ::String)::Q where {Q<:MexcAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:MexcCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:MexcCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::MexcClient, ::MexcPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::MexcClient, ::MexcPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MEXC-APIKEY" => client.public_key,
    ]
end

function CryptoExchangeAPIs.request_headers(client::MexcClient, ::MexcAccessQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MEXC-APIKEY" => client.public_key,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

include("Futures/Futures.jl")
using .Futures

end
