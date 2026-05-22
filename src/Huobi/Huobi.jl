module Huobi

export HuobiCommonQuery,
    HuobiPublicQuery,
    HuobiAccessQuery,
    HuobiPrivateQuery,
    HuobiAPIError,
    HuobiConfig,
    HuobiClient,
    HuobiData

using Serde
using EnumX
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError,
    AbstractAPIsData,
    AbstractAPIsQuery,
    AbstractAPIsClient,
    AbstractAPIsConfig,
    RequestOptions

abstract type HuobiData <: AbstractAPIsData end
abstract type HuobiCommonQuery  <: AbstractAPIsQuery end
abstract type HuobiPublicQuery  <: HuobiCommonQuery end
abstract type HuobiAccessQuery  <: HuobiCommonQuery end
abstract type HuobiPrivateQuery <: HuobiCommonQuery end

@enumx Status begin
    ok
    error
end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `data::D`: The body data in response.

## Optional fields
- `status::Status`: Status of API response.
- `ch::String`: The data stream. It may be empty as some API doesn't have data stream.
- `ts::NanoDate`: The UTC timestamp when API respond, the unit is millisecond.
- `code::Int64`: Response code.
"""
struct Data{D} <: AbstractAPIsData
    status::Maybe{Status.T}
    ch::Maybe{String}
    ts::Maybe{NanoDate}
    code::Maybe{Int64}
    data::D
end

"""
    DataTick{D} <: AbstractAPIsData

## Required fields
- `tick::D`: The body tick in response.
- `status::Status`: Status of API response.
- `ch::String`: The data stream. It may be empty as some API doesn't have data stream.
- `ts::NanoDate`: The UTC timestamp when API respond.
"""
struct DataTick{D} <: AbstractAPIsData
    status::Status.T
    ch::String
    ts::NanoDate
    tick::D
end

"""
    HuobiConfig <: AbstractAPIsConfig

Huobi client config. Transport options live in `request_options::RequestOptions`.

## Required fields
- `base_url::String`: Base URL for the client.

## Optional fields
- `public_key::String`: Public key for authentication.
- `secret_key::String`: Secret key for authentication.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct HuobiConfig <: AbstractAPIsConfig
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

"""
    HuobiClient <: AbstractAPIsClient

Client for interacting with Huobi exchange API.

## Fields
- `config::HuobiConfig`: Configuration with base URL, API keys, and settings
- `curl_client::CurlClient`: HTTP client for API requests
"""
mutable struct HuobiClient <: AbstractAPIsClient
    config::HuobiConfig
    curl_client::CurlClient

    function HuobiClient(config::HuobiConfig)
        new(config, CurlClient())
    end

    function HuobiClient(; kw...)
        return HuobiClient(HuobiConfig(; kw...))
    end
end

"""
    isopen(client::HuobiClient) -> Bool

Checks if the `client` instance is open and ready for API requests.
"""
Base.isopen(c::HuobiClient) = isopen(c.curl_client)

"""
    close(client::HuobiClient)

Closes the `client` instance and free associated resources.
"""
Base.close(c::HuobiClient) = close(c.curl_client)

"""
    public_config = HuobiConfig(; base_url = "https://api.huobi.pro")
"""
const public_config = HuobiConfig(; base_url = "https://api.huobi.pro")

"""
    HuobiAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `err_code::String`: Error code.
- `err_msg::String`: Error message.

## Optional fields
- `ts::NanoDate`: he UTC timestamp when API respond.
- `status::String`: Status of API response.
- `code::Int64`: Response code.
"""
struct HuobiAPIError{T} <: AbstractAPIsError
    err_code::String
    err_msg::String
    ts::Maybe{NanoDate}
    status::Maybe{String}
    data::Nothing
    code::Maybe{Int64}

    function HuobiAPIError(err_code::String, err_msg::String, x...)
        return new{Symbol(err_code)}(err_code, err_msg, x...)
    end
end

function Base.show(io::IO, e::HuobiAPIError)
    return print(io, "code = ", "\"", e.err_code, "\"", ", ", "msg = ", "\"", e.err_msg, "\"")
end

CryptoExchangeAPIs.error_type(::HuobiClient) = HuobiAPIError

function CryptoExchangeAPIs.request_sign!(::HuobiClient, query::Q, ::String)::Q where {Q<:HuobiPublicQuery}
    return query
end

function CryptoExchangeAPIs.request_sign!(client::HuobiClient, query::Q, endpoint::String)::Q where {Q<:HuobiPrivateQuery}
    query.AccessKeyId = client.config.public_key
    query.Timestamp = now(UTC)
    query.SignatureMethod = "HmacSHA256"
    query.SignatureVersion  = "2"
    query.Signature = nothing
    body::String = Serde.to_query(query)
    endpoint = string("/", endpoint)
    host = last(split(client.config.base_url, "//"))
    salt = join(["GET", host, endpoint, body], "\n")
    query.Signature = Base64.base64encode(digest("sha256", client.config.secret_key, salt))
    return query
end

function CryptoExchangeAPIs.request_body(::Q)::String where {Q<:HuobiPublicQuery}
    return ""
end

function CryptoExchangeAPIs.request_body(query::Q)::String where {Q<:HuobiPrivateQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(query::Q)::String where {Q<:HuobiPublicQuery}
    return Serde.to_query(query)
end

function CryptoExchangeAPIs.request_query(::Q)::String where {Q<:HuobiPrivateQuery}
    return ""
end

function CryptoExchangeAPIs.request_headers(client::HuobiClient, ::HuobiCommonQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Market/Market.jl")
include("V1/V1.jl")
include("V2/V2.jl")

end
