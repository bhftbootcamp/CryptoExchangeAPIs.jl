module Okex

export OkexCommonQuery,
    OkexPublicQuery,
    OkexAccessQuery,
    OkexPrivateQuery,
    OkexAPIError,
    OkexClient,
    OkexData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type OkexData <: AbstractAPIsData end
abstract type OkexCommonQuery  <: AbstractAPIsQuery end
abstract type OkexPublicQuery  <: OkexCommonQuery end
abstract type OkexAccessQuery  <: OkexCommonQuery end
abstract type OkexPrivateQuery <: OkexCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `msg::String`: Return message.
- `code::Int64`: Return code.
- `data::Vector{D}`: Result values.
"""
struct Data{D<:AbstractAPIsData} <: AbstractAPIsData
    msg::String
    code::Int64
    data::Vector{D}

    function Data{D}(msg::String, code::Int64, data::Vector{D}) where {D <: AbstractAPIsData}
        @assert code == 0
        return new{D}(msg, code, data)
    end
end

"""
    OkexClient <: AbstractAPIsClient

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
Base.@kwdef struct OkexClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    OkexAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.
- `msg::String`: Error message.

## Optional fields
- `data::Vector{Any}`: Error result data.
"""
struct OkexAPIError{T} <: AbstractAPIsError
    code::Int64
    msg::String
    data::Maybe{Vector{Any}}

    function OkexAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::OkexClient) = OkexAPIError

function Base.show(io::IO, e::OkexAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::OkexClient, query::Q, ::String)::Q where {Q<:OkexPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::OkexClient, query::Q, endpoint::String)::Q where {Q<:OkexPrivateQuery}
    query.signature = nothing
    str_query = Serde.to_query(query)
    body::String = isempty(str_query) ? "" : "?" * str_query
    query.timestamp = Dates.now(UTC)
    salt = string(Dates.format(query.timestamp, "yyyy-mm-ddTHH:MM:SS.sss\\Z"), "GET", "/", endpoint, body)
    query.signature = Base64.base64encode(digest("sha256", client.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:OkexCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:OkexCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::OkexClient, ::OkexPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::OkexClient, query::OkexPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "OK-ACCESS-TIMESTAMP" => Dates.format(query.timestamp, "yyyy-mm-ddTHH:MM:SS.sss\\Z"),
        "Content-Type" => "application/json",
        "OK-ACCESS-KEY" => client.public_key,
        "OK-ACCESS-SIGN" => query.signature,
        "OK-ACCESS-PASSPHRASE" => client.passphrase,
    ]
end

@enum InstType begin
    SPOT
    SWAP
    FUTURES
    OPTION
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

include("Common/Common.jl")
using .Common

end
