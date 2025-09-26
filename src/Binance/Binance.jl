module Binance

export BinanceCommonQuery,
    BinancePublicQuery,
    BinanceAccessQuery,
    BinancePrivateQuery,
    BinanceAPIError,
    BinanceClient,
    BinanceData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs

import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig

abstract type BinanceData <: AbstractAPIsData end
abstract type BinanceCommonQuery  <: AbstractAPIsQuery end
abstract type BinancePublicQuery  <: BinanceCommonQuery end
abstract type BinanceAccessQuery  <: BinanceCommonQuery end
abstract type BinancePrivateQuery <: BinanceCommonQuery end

"""
    BinanceConfig <: AbstractAPIsConfig

Binance client config.

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
Base.@kwdef struct BinanceConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    BinanceClient <: AbstractAPIsClient

Client for interacting with Binance exchange API.

## Fields
- `config::BinanceConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
Base.@kwdef mutable struct BinanceClient <: AbstractAPIsClient
    config::BinanceConfig
    curl_client::CurlClient

    function BinanceClient(config::BinanceConfig, curl_client::CurlClient)
        new(config, curl_client)
    end

    function BinanceClient(config::BinanceConfig)
        new(config, CurlClient())
    end
end

"""
    isopen(client::BinanceClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::BinanceClient) = isopen(c.curl_client)

"""
    close(client::BinanceClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::BinanceClient) = close(c.curl_client)

function binance_client(; kw...)
    return BinanceClient(BinanceConfig(; kw...))
end

binance_client(config::BinanceConfig) = BinanceClient(config)

function binance_client(f::Function, x...; kw...)
    client = binance_client(x...; kw...)
    try
        f(client)
    finally
        close(client)
    end
end

"""
    public_config = BinanceConfig(; base_url = "https://api.binance.com")
"""
const public_config = BinanceConfig(; base_url = "https://api.binance.com")

"""
    public_fapi_config = BinanceConfig(; base_url = "https://fapi.binance.com")
"""
const public_fapi_config = BinanceConfig(; base_url = "https://fapi.binance.com")

"""
    BinanceAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.

## Optional fields
- `type::String`: Type of error.
- `msg::String`: Error message.
"""
struct BinanceAPIError{T} <: AbstractAPIsError
    code::Int64
    type::Maybe{String}
    msg::Maybe{String}

    function BinanceAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::BinanceClient) = BinanceAPIError

function Base.show(io::IO, e::BinanceAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::BinanceClient, query::Q, ::String)::Q where {Q<:BinancePublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BinanceClient, query::Q, ::String)::Q where {Q<:BinancePrivateQuery}
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    str_query = Serde.to_query(query)
    query.signature = hexdigest("sha256", client.config.secret_key, str_query)
    return query
end

function CryptoExchangeAPIs.request_sign!(::BinanceClient, query::Q, ::String)::Q where {Q<:BinanceAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BinanceCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BinanceCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinancePublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinancePrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MBX-APIKEY" => client.config.public_key,
    ]
end

function CryptoExchangeAPIs.request_headers(client::BinanceClient, ::BinanceAccessQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MBX-APIKEY" => client.config.public_key,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("API/API.jl")
using .API

include("SAPI/SAPI.jl")
using .SAPI

include("FAPI/FAPI.jl")
using .FAPI

include("Futures/Futures.jl")
using .Futures

end
