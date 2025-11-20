module Hyperliquid

export HyperliquidCommonQuery,
    HyperliquidPublicQuery,
    HyperliquidAPIError,
    HyperliquidClient,
    HyperliquidData

using Serde
using Dates, NanoDates, TimeZones, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig,
    RequestOptions

abstract type HyperliquidData <: AbstractAPIsData end
abstract type HyperliquidCommonQuery <: AbstractAPIsQuery end
abstract type HyperliquidPublicQuery <: HyperliquidCommonQuery end

"""
    HyperliquidConfig <: AbstractAPIsConfig

Hyperliquid client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct HyperliquidConfig <: AbstractAPIsConfig
    base_url::String
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    HyperliquidClient <: AbstractAPIsClient

Client for interacting with Hyperliquid exchange API.

## Fields
- `config::HyperliquidConfig`: Configuration with base URL and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct HyperliquidClient <: AbstractAPIsClient
    config::HyperliquidConfig
    curl_client::CurlClient

    function HyperliquidClient(config::HyperliquidConfig)
        new(config, CurlClient())
    end

    function HyperliquidClient(; kw...)
        return HyperliquidClient(HyperliquidConfig(; kw...))
    end
end

"""
    isopen(client::HyperliquidClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::HyperliquidClient) = isopen(c.curl_client)

"""
    close(client::HyperliquidClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::HyperliquidClient) = close(c.curl_client)

"""
    public_config = HyperliquidConfig(; base_url = "https://api.hyperliquid.xyz")
"""
const public_config = HyperliquidConfig(; base_url = "https://api.hyperliquid.xyz")

"""
    HyperliquidAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `message::String`: Error message.
"""
struct HyperliquidAPIError{T} <: AbstractAPIsError
    message::String

    function HyperliquidAPIError(message::String, x...)
        return new{Symbol(message)}(message, x...)
    end
end

CryptoExchangeAPIs.error_type(::HyperliquidClient) = HyperliquidAPIError

function Base.show(io::IO, e::HyperliquidAPIError)
    return print(io, "message = ", "\"", e.message, "\"")
end

# Handle null response from API as error
Serde.deser(::Type{HyperliquidAPIError}, ::Nothing) = HyperliquidAPIError("null response")

function CryptoExchangeAPIs.request_sign!(::HyperliquidClient, query::Q, ::String)::Q where {Q<:HyperliquidPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_body(query::Q)::String where {Q<:HyperliquidCommonQuery}
    return Serde.to_json(query)
end

function CryptoExchangeAPIs.request_query(::Q)::String where {Q<:HyperliquidCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_headers(client::HyperliquidClient, ::HyperliquidPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Info/Info.jl")

end

