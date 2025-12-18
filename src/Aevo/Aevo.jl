module Aevo

export AevoCommonQuery,
    AevoPublicQuery,
    AevoAccessQuery,
    AevoAPIError,
    AevoConfig,
    AevoClient,
    AevoData

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

abstract type AevoData <: AbstractAPIsData end
abstract type AevoCommonQuery  <: AbstractAPIsQuery end
abstract type AevoPublicQuery  <: AevoCommonQuery end
abstract type AevoAccessQuery  <: AevoCommonQuery end

"""
    AevoConfig <: AbstractAPIsConfig

Aevo client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client. 

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct AevoConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    AevoClient <: AbstractAPIsClient

Client for interacting with Aevo exchange API.

## Fields
- `config::AevoConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct AevoClient <: AbstractAPIsClient
    config::AevoConfig
    curl_client::CurlClient

    function AevoClient(config::AevoConfig)
        new(config, CurlClient())
    end

    function AevoClient(; kw...)
        return AevoClient(AevoConfig(; kw...))
    end
end

"""
    isopen(client::AevoClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::AevoClient) = isopen(c.curl_client)

"""
    close(client::AevoClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::AevoClient) = close(c.curl_client)

"""
    public_config = AevoConfig(; base_url = "https://api.aevo.xyz")
"""
const public_config = AevoConfig(; base_url = "https://api.aevo.xyz")

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

include("Assets.jl")
using .Assets

include("FundingHistory.jl")
using .FundingHistory

include("Statistics.jl")
using .Statistics

end
