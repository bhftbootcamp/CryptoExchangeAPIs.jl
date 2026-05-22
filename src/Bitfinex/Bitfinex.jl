module Bitfinex

export BitfinexCommonQuery,
    BitfinexPublicQuery,
    BitfinexAccessQuery,
    BitfinexPrivateQuery,
    BitfinexAPIError,
    BitfinexConfig,
    BitfinexClient,
    BitfinexData

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

abstract type BitfinexData <: AbstractAPIsData end
abstract type BitfinexCommonQuery  <: AbstractAPIsQuery end
abstract type BitfinexPublicQuery  <: BitfinexCommonQuery end
abstract type BitfinexAccessQuery  <: BitfinexCommonQuery end
abstract type BitfinexPrivateQuery <: BitfinexCommonQuery end

"""
    BitfinexConfig <: AbstractAPIsConfig

Bitfinex client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct BitfinexConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    BitfinexClient <: AbstractAPIsClient

Client for interacting with Bitfinex exchange API.

## Fields
- `config::BitfinexConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct BitfinexClient <: AbstractAPIsClient
    config::BitfinexConfig
    curl_client::CurlClient

    function BitfinexClient(config::BitfinexConfig)
        new(config, CurlClient())
    end

    function BitfinexClient(; kw...)
        return BitfinexClient(BitfinexConfig(; kw...))
    end
end

"""
    isopen(client::BitfinexClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::BitfinexClient) = isopen(c.curl_client)

"""
    close(client::BitfinexClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::BitfinexClient) = close(c.curl_client)

"""
    public_config = BitfinexConfig(; base_url = "https://api-pub.bitfinex.com")
"""
const public_config = BitfinexConfig(; base_url = "https://api-pub.bitfinex.com")

"""
    BitfinexAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Optional fields
- `type::String`: Error type.
- `code::Int64`: Error code.
- `msg::String`: Error message.
"""
struct BitfinexAPIError{T} <: AbstractAPIsError
    type::Maybe{String}
    code::Maybe{Int64}
    msg::Maybe{String}

    function BitfinexAPIError(error::String, code::Int64, x...)
        return new{code}(error, code, x...)
    end
end

function Base.show(io::IO, e::BitfinexAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

CryptoExchangeAPIs.error_type(::BitfinexClient) = BitfinexAPIError

function CryptoExchangeAPIs.request_sign!(::BitfinexClient, query::Q, ::String)::Q where {Q<:BitfinexPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BitfinexClient, query::Q, endpoint::String)::Q where {Q<:BitfinexPrivateQuery}
    query.nonce = string(round(Int64, 1000 * datetime2unix(now(UTC))))
    signature_payload = string("/api/", endpoint, query.nonce)
    query.signature = hexdigest("sha384", client.config.secret_key, signature_payload)
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BitfinexCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BitfinexCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BitfinexClient, ::BitfinexPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::BitfinexClient, query::BitfinexPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "bfx-signature" => query.signature,
        "bfx-apikey" => client.config.public_key,
        "bfx-nonce" => query.nonce,
        "Content-type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("V2/V2.jl")
using .V2

end
