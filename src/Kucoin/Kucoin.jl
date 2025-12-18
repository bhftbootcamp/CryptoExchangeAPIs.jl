module Kucoin

export KucoinCommonQuery,
    KucoinPublicQuery,
    KucoinAccessQuery,
    KucoinPrivateQuery,
    KucoinAPIError,
    KucoinConfig,
    KucoinClient,
    KucoinData

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

abstract type KucoinData <: AbstractAPIsData end
abstract type KucoinCommonQuery  <: AbstractAPIsQuery end
abstract type KucoinPublicQuery  <: KucoinCommonQuery end
abstract type KucoinAccessQuery  <: KucoinCommonQuery end
abstract type KucoinPrivateQuery <: KucoinCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `code::Int64`: Result code.
- `data::D`: Result data.
"""
struct Data{D<:Union{A,Vector{A}} where {A<:AbstractAPIsData}} <: AbstractAPIsData
    code::Int64
    data::D
end

"""
    Page{D} <: AbstractAPIsData

## Required fields
- `pageSize::Int64`: Number of results per request.
- `totalNum::Int64`: Total number of results.
- `currentPage::Int64`: Current request page.
- `totalPage::Int64`: Total request page.
- `items::Vector{D}`: Result data.
"""
struct Page{D<:AbstractAPIsData} <:AbstractAPIsData
    pageSize::Int64
    totalNum::Int64
    currentPage::Int64
    totalPage::Int64
    items::Vector{D}
end

"""
    KucoinConfig <: AbstractAPIsConfig

Kucoin client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `passphrase::String`: Passphrase for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct KucoinConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    KucoinClient <: AbstractAPIsClient

Client for interacting with Kucoin exchange API.

## Fields
- `config::KucoinConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct KucoinClient <: AbstractAPIsClient
    config::KucoinConfig
    curl_client::CurlClient

    function KucoinClient(config::KucoinConfig)
        new(config, CurlClient())
    end

    function KucoinClient(; kw...)
        return KucoinClient(KucoinConfig(; kw...))
    end
end

"""
    isopen(client::KucoinClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::KucoinClient) = isopen(c.curl_client)

"""
    close(client::KucoinClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::KucoinClient) = close(c.curl_client)

const public_config         = KucoinConfig(; base_url = "https://api.kucoin.com")
const public_futures_config = KucoinConfig(; base_url = "https://api-futures.kucoin.com")
const public_web_config     = KucoinConfig(; base_url = "https://www.kucoin.com")

"""
    KucoinAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.
- `msg::String`: Error message.
"""
struct KucoinAPIError{T} <: AbstractAPIsError
    code::Int64
    msg::String

    function KucoinAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::KucoinClient) = KucoinAPIError

function Base.show(io::IO, e::KucoinAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.msg, "\"")
end

function CryptoExchangeAPIs.request_sign!(::KucoinClient, query::Q, ::String)::Q where {Q<:KucoinPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::KucoinClient, query::Q, endpoint::String)::Q where {Q <: KucoinPrivateQuery}
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    salt = join([string(round(Int64, 1000 * datetime2unix(query.timestamp))), "GET/$endpoint?", Serde.to_query(query)])
    query.passphrase = Base64.base64encode(digest("sha256", client.config.secret_key, client.config.passphrase))
    query.signature = Base64.base64encode(digest("sha256", client.config.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:KucoinCommonQuery}
    return ""
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:KucoinCommonQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_headers(client::KucoinClient, ::KucoinPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoExchangeAPIs.request_headers(client::KucoinClient, query::KucoinPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "KC-API-SIGN" => query.signature,
        "KC-API-TIMESTAMP" => string(round(Int64, 1000 * datetime2unix(query.timestamp))),
        "KC-API-KEY" => client.config.public_key,
        "KC-API-PASSPHRASE" => query.passphrase,
        "Content-Type" => "application/json",
        "KC-API-KEY-VERSION" => "2",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("API/API.jl")
include("_API/_API.jl")

end
