module Gateio

export GateioCommonQuery,
    GateioPublicQuery,
    GateioAccessQuery,
    GateioPrivateQuery,
    GateioAPIError,
    GateioConfig,
    GateioClient,
    GateioData

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

abstract type GateioData <: AbstractAPIsData end
abstract type GateioCommonQuery  <: AbstractAPIsQuery end
abstract type GateioPublicQuery  <: GateioCommonQuery end
abstract type GateioAccessQuery  <: GateioCommonQuery end
abstract type GateioPrivateQuery <: GateioCommonQuery end

"""
    GateioConfig <: AbstractAPIsConfig

Gate.io client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct GateioConfig <: AbstractAPIsConfig
    base_url::String = "https://api.gateio.ws"
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    GateioClient <: AbstractAPIsClient

Client for interacting with Gate.io exchange API.

## Fields
- `config::GateioConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct GateioClient <: AbstractAPIsClient
    config::GateioConfig
    curl_client::CurlClient

    function GateioClient(config::GateioConfig)
        new(config, CurlClient())
    end

    function GateioClient(; kw...)
        return GateioClient(GateioConfig(; kw...))
    end
end

"""
    isopen(client::GateioClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::GateioClient) = isopen(c.curl_client)

"""
    close(client::GateioClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::GateioClient) = close(c.curl_client)

"""
    public_config = GateioConfig(; base_url = "https://api.gateio.ws")
"""
const public_config = GateioConfig(; base_url = "https://api.gateio.ws")

"""
    GateioAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `label::String`: Error label.
- `message::String`: Error message.
"""
struct GateioAPIError{T} <: AbstractAPIsError
    label::String
    message::Maybe{String}

    function GateioAPIError(label::String, x...)
        return new{Symbol(label)}(label, x...)
    end
end

CryptoExchangeAPIs.error_type(::GateioClient) = GateioAPIError

function Base.show(io::IO, e::GateioAPIError)
    return print(io, "label = ", "\"", e.label, "\"", ", ", "msg = ", "\"", e.message, "\"")
end

function CryptoExchangeAPIs.request_sign!(::GateioClient, query::Q, ::String)::Q where {Q<:GateioPublicQuery}
    return query
end

function gen_sign(method::String, query::Q, url::String)::String where {Q<:GateioPrivateQuery}
    t = string(round(Int64, datetime2unix(query.signTimestamp)))
    query_string::String = Serde.to_query(query)
    hashed_payload = hexdigest("sha512", "")
    sign = join([method, url, query_string, hashed_payload, t], "\n")
    return sign
end

function CryptoExchangeAPIs.request_sign!(client::GateioClient, query::Q, endpoint::String)::Q where {Q<:GateioPrivateQuery}
    query.signTimestamp = Dates.now(UTC)
    query.signature = nothing
    endpoint = "/" * endpoint
    query.signature = hexdigest("sha512", client.config.secret_key, gen_sign("GET", query, endpoint))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:GateioCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:GateioCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::GateioClient, ::GateioPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::GateioClient, query::GateioPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "KEY"          => client.config.public_key,
        "SIGN"         => query.signature,
        "Timestamp"    => string(round(Int64, datetime2unix(query.signTimestamp))),
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("API/API.jl")
using .API

end
