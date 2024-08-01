module Bybit

export BybitCommonQuery,
    BybitPublicQuery,
    BybitAccessQuery,
    BybitPrivateQuery,
    BybitAPIError,
    BybitClient,
    BybitData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type BybitData <: AbstractAPIsData end
abstract type BybitCommonQuery  <: AbstractAPIsQuery end
abstract type BybitPublicQuery  <: BybitCommonQuery end
abstract type BybitAccessQuery  <: BybitCommonQuery end
abstract type BybitPrivateQuery <: BybitCommonQuery end

"""
    List{D} <: AbstractAPIsData

## Required fields
- `list::Vector{D}`: Result values.

## Optional fields
- `nextPageCursor::String`: Pagination cursor.
- `category::String`: Product type
"""
struct List{D<:AbstractAPIsData} <: AbstractAPIsData
    list::Vector{D}
    nextPageCursor::Maybe{String}
    category::Maybe{String}
end

"""
    Rows{D} <: AbstractAPIsData

## Required fields
- `rows::Vector{D}`: Result values.

## Optional fields
- `nextPageCursor::String`: Pagination cursor.
"""
struct Rows{D<:AbstractAPIsData} <: AbstractAPIsData
    rows::Vector{D}
    nextPageCursor::Maybe{String}
end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `retCode::Int64`: Return code.
- `retMsg::String`: Return msg.
- `result::D`: Request result data.
- `retExtInfo::Dict{String,Any}`: Request extended information.
- `time::NanoDate`: Current timestamp (ms).
"""
struct Data{D<:Maybe{<:AbstractAPIsData}} <: AbstractAPIsData
    retCode::Int64
    retMsg::String
    result::D
    retExtInfo::Dict{String,Any}
    time::NanoDate
end

"""
    BybitClient <: AbstractAPIsClient

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
Base.@kwdef struct BybitClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    BybitAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `retCode::Int64`: Error code.
- `retMsg::String`: Error message.
- `result::Dict{String,Any}`: Error result data.
- `retExtInfo::Dict{String,Any}`: Extended error information.
- `time::NanoDate`: Error timestamp (ms).
"""
struct BybitAPIError{T} <: AbstractAPIsError
    retCode::Int64
    retMsg::String
    result::Dict{String,Any}
    retExtInfo::Dict{String,Any}
    time::NanoDate

    function BybitAPIError(retCode::Int64, x...)
        @assert !iszero(retCode) # retCode = 0 means success
        return new{retCode}(retCode, x...)
    end
end

CryptoExchangeAPIs.error_type(::BybitClient) = BybitAPIError

function Base.show(io::IO, e::BybitAPIError)
    return print(io, "code = ", "\"", e.retCode, "\"", ", ", "msg = ", "\"", e.retMsg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::BybitClient, query::Q, ::String)::Q where {Q<:BybitPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BybitClient, query::Q, ::String)::Q where {Q<:BybitPrivateQuery}
    query.timestamp = Dates.now(UTC)
    query.api_key = client.public_key
    query.signature = nothing
    body::String = Serde.to_query(query)
    salt = join([string(round(Int64, 1000 * datetime2unix(query.timestamp))), client.public_key, query.recv_window, body])
    query.signature = hexdigest("sha256", client.secret_key, salt)
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BybitCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BybitCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BybitClient, ::BybitPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::BybitClient, query::BybitPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "X-BAPI-SIGN-TYPE" => "2",
        "X-BAPI-SIGN" => query.signature,
        "X-BAPI-API-KEY" => client.public_key,
        "X-BAPI-TIMESTAMP" => string(round(Int64, 1000 * datetime2unix(query.timestamp))),
        "X-BAPI-RECV-WINDOW" => string(query.recv_window),
        "Content-Type" => "application/x-www-form-urlencoded",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
