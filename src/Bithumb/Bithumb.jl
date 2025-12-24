module Bithumb

export BithumbCommonQuery,
    BithumbPublicQuery,
    BithumbAccessQuery,
    BithumbPrivateQuery,
    BithumbAPIError,
    BithumbConfig,
    BithumbClient,
    BithumbData

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

abstract type BithumbData <: AbstractAPIsData end
abstract type BithumbCommonQuery  <: AbstractAPIsQuery end
abstract type BithumbPublicQuery  <: BithumbCommonQuery end
abstract type BithumbAccessQuery  <: BithumbCommonQuery end
abstract type BithumbPrivateQuery <: BithumbCommonQuery end

"""
    Data{D<:Union{A,Vector{A},Dict{String,A}} where {A<:AbstractAPIsData}} <: AbstractAPIsData

## Required fields
- `status::String`: Request status.
- `data::D`: Request result data.

## Optional fields
- `date::NanoDate`: Current time.
"""
struct Data{D<:Union{A,Vector{A},Dict{String,A}} where {A<:AbstractAPIsData}} <: AbstractAPIsData
    status::String
    date::Maybe{NanoDate}
    data::D
end

struct WebData{D}
    status::Int
    code::String
    message::String
    data::D
end

"""
    BithumbConfig <: AbstractAPIsConfig

Bithumb client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client. 

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct BithumbConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    BithumbClient <: AbstractAPIsClient

Client for interacting with Bithumb exchange API.

## Fields
- `config::BithumbConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct BithumbClient <: AbstractAPIsClient
    config::BithumbConfig
    curl_client::CurlClient

    function BithumbClient(config::BithumbConfig)
        new(config, CurlClient())
    end

    function BithumbClient(; kw...)
        return BithumbClient(BithumbConfig(; kw...))
    end
end

"""
    isopen(client::BithumbClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::BithumbClient) = isopen(c.curl_client)

"""
    close(client::BithumbClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::BithumbClient) = close(c.curl_client)

const public_config = BithumbConfig(; base_url = "https://api.bithumb.com")
const public_web_config = BithumbConfig(; base_url = "https://gw.bithumb.com")

"""
    BithumbAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `status::Int64`: Error status code.

## Optional fields
- `message::String`: Error message.
"""
struct BithumbAPIError{T} <: AbstractAPIsError
    status::Int64
    message::Maybe{String}

    function BithumbAPIError(status::Int64, x...)
        iszero(status) && throw(ArgumentError("API response code must not be non-zero"))
        return new{status}(status, x...)
    end
end

function Base.show(io::IO, e::BithumbAPIError)
    return print(io, "status = ", "\"", e.status, "\"", ", ", "message = ", "\"", e.message, "\"")
end

CryptoExchangeAPIs.error_type(::BithumbClient) = BithumbAPIError

function CryptoExchangeAPIs.request_sign!(::BithumbClient, query::Q, ::String)::Q where {Q<:BithumbPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::BithumbClient, query::Q, endpoint::String)::Q where {Q<:BithumbPrivateQuery}
    query.nonce = Dates.now(UTC)
    query.endpoint = Serde.SerQuery.escape_query("/" * endpoint)
    query.signature = nothing
    body = Serde.to_query(query)
    salt = string("/", endpoint, Char(0), body, Char(0), round(Int64, 1000 * datetime2unix(query.nonce)))
    query.signature = Base64.base64encode(hexdigest("sha512", client.config.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_sign!(::BithumbClient, query::Q, ::String)::Q where {Q<:BithumbAccessQuery}
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:BithumbCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:BithumbCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::BithumbClient, ::BithumbPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::BithumbClient, query::BithumbPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Api-Key"   => client.config.public_key,
        "Api-Sign"  => query.signature,
        "Api-Nonce" => string(round(Int64, 1000 * datetime2unix(query.nonce))),
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Public/Public.jl")
using .Public

include("V1/V1.jl")
using .V1

include("Info/Info.jl")
using .Info

include("Exchange/Exchange.jl")
using .Exchange

end
