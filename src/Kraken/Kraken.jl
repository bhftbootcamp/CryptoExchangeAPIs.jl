module Kraken

export KrakenCommonQuery,
    KrakenPublicQuery,
    KrakenAccessQuery,
    KrakenPrivateQuery,
    KrakenInternalPublicQuery,
    KrakenAPIError,
    KrakenConfig,
    KrakenClient,
    KrakenData

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

abstract type KrakenData <: AbstractAPIsData end
abstract type KrakenCommonQuery  <: AbstractAPIsQuery end
abstract type KrakenPublicQuery  <: KrakenCommonQuery end
abstract type KrakenAccessQuery  <: KrakenCommonQuery end
abstract type KrakenPrivateQuery <: KrakenCommonQuery end
abstract type KrakenInternalPublicQuery <: KrakenPublicQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `error::Vector{Any}`: Error values.
- `result::D`: Request result data.
"""
struct Data{D} <: AbstractAPIsData
    error::Vector{Any}
    result::D
end

struct InternalData{D} <: AbstractAPIsData
    result::D
end

"""
    KrakenConfig <: AbstractAPIsConfig

Kraken client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct KrakenConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    KrakenClient <: AbstractAPIsClient

Client for interacting with Kraken exchange API.

## Fields
- `config::KrakenConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct KrakenClient <: AbstractAPIsClient
    config::KrakenConfig
    curl_client::CurlClient

    function KrakenClient(config::KrakenConfig)
        new(config, CurlClient())
    end

    function KrakenClient(; kw...)
        return KrakenClient(KrakenConfig(; kw...))
    end
end

Base.isopen(c::KrakenClient) = isopen(c.curl_client)
Base.close(c::KrakenClient)  = close(c.curl_client)

const public_config          = KrakenConfig(; base_url = "https://api.kraken.com")
const public_status_config   = KrakenConfig(; base_url = "https://status.kraken.com")
const public_internal_config = KrakenConfig(; base_url = "https://iapi.kraken.com")

"""
    KrakenAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `error::Vector{String}`: Error values.
"""
struct KrakenAPIError{T} <: AbstractAPIsError
    error::Vector{String}

    function KrakenAPIError(error::Vector{String})
        return new{Symbol(error[1])}(error)
    end
end

function Base.show(io::IO, e::KrakenAPIError)
    return print(io, "error = ", "\"", e.error, "\"")
end

CryptoExchangeAPIs.error_type(::KrakenClient) = KrakenAPIError

function CryptoExchangeAPIs.request_sign!(::KrakenClient, query::Q, ::String)::Q where {Q<:KrakenPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::KrakenClient, query::Q, endpoint::String)::Q where {Q<:KrakenPrivateQuery}
    query.nonce = Dates.now(UTC)
    body::String = Serde.to_query(query)
    encoded = Vector{UInt8}(string(round(Int64, 1000 * datetime2unix(query.nonce)), body))
    bdigest = digest("sha256", encoded)
    salt = [Vector{UInt8}("/" * endpoint); bdigest]
    query.signature = base64encode(digest("sha512", base64decode(client.config.secret_key), salt))
    return query
end

function CryptoExchangeAPIs.request_sign!(::KrakenClient, query::Q, ::String)::Q where {Q<:KrakenAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:KrakenPublicQuery}
    return ""
end

function CryptoExchangeAPIs.request_body(query::Q)::String where {Q<:KrakenPrivateQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:KrakenPublicQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(::Q)::String where {Q<:KrakenPrivateQuery}
    return ""
end

function CryptoExchangeAPIs.request_headers(::KrakenClient, ::KrakenPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

function CryptoExchangeAPIs.request_headers(::KrakenClient, ::KrakenInternalPublicQuery)
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "Referer" => "https://support.kraken.com/",
    ]
end

function CryptoExchangeAPIs.request_headers(client::KrakenClient, query::KrakenPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/x-www-form-urlencoded",
        "API-Key"  => client.config.public_key,
        "API-Sign" => query.signature,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("V0/V0.jl")
include("API/API.jl")

end
