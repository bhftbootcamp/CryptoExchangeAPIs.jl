module Bybit

export BybitCommonQuery,
    BybitPublicQuery,
    BybitAccessQuery,
    BybitPrivateQuery,
    BybitAPIError,
    BybitConfig,
    BybitClient,
    BybitData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig,
    RequestOptions

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
struct Data{D} <: AbstractAPIsData
    retCode::Int64
    retMsg::String
    result::D
    retExtInfo::Dict{String,Any}
    time::NanoDate
    function Data{D}(
        retCode::Int64,
        retMsg::String,
        result::D,
        retExtInfo::Dict{String,Any},
        time::NanoDate,
    ) where {D<:Maybe{AbstractAPIsData}}
        !iszero(retCode) && throw(ArgumentError("API response code must be zero"))
        return new{D}(retCode, retMsg, result, retExtInfo, time)
    end
end

"""
    BybitConfig <: AbstractAPIsConfig

Bybit client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct BybitConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    BybitClient <: AbstractAPIsClient

Client for interacting with Bybit exchange API.

## Fields
- `config::BybitConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct BybitClient <: AbstractAPIsClient
    config::BybitConfig
    curl_client::CurlClient

    function BybitClient(config::BybitConfig)
        new(config, CurlClient())
    end

    function BybitClient(; kw...)
        return BybitClient(BybitConfig(; kw...))
    end
end

"""
    isopen(client::BybitClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::BybitClient) = isopen(c.curl_client)

"""
    close(client::BybitClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::BybitClient) = close(c.curl_client)

"""
    public_config = BybitConfig(; base_url = "https://api.bybit.com")
"""
const public_config = BybitConfig(; base_url = "https://api.bybit.com")

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
        iszero(retCode) && throw(ArgumentError("API response code must not be zero"))
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
    query.api_key = client.config.public_key
    query.signature = nothing
    body::String = Serde.to_query(query)
    salt = join([string(round(Int64, 1000 * datetime2unix(query.timestamp))), client.config.public_key, query.recv_window, body])
    query.signature = hexdigest("sha256", client.config.secret_key, salt)
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
        "X-BAPI-API-KEY" => client.config.public_key,
        "X-BAPI-TIMESTAMP" => string(round(Int64, 1000 * datetime2unix(query.timestamp))),
        "X-BAPI-RECV-WINDOW" => string(query.recv_window),
        "Content-Type" => "application/x-www-form-urlencoded",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("V5/V5.jl")

end
