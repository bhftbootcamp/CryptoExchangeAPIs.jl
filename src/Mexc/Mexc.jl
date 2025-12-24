module Mexc

export MexcCommonQuery,
       MexcPublicQuery,
       MexcAccessQuery,
       MexcSpotPrivateQuery,
       MexcAPIError,
       MexcClient,
       MexcSpotClient,
       MexcFuturesClient,
       MexcConfig,
       MexcData

using Serde
using Dates, NanoDates, TimeZones, SHA, Base64, Nettle, EasyCurl
using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery,
    AbstractAPIsClient, AbstractAPIsConfig, RequestOptions

# ---------------------------------------------------------------------------

abstract type MexcClient <: AbstractAPIsClient end
abstract type MexcData <: AbstractAPIsData end
abstract type MexcCommonQuery  <: AbstractAPIsQuery end
abstract type MexcPublicQuery  <: MexcCommonQuery end
abstract type MexcAccessQuery  <: MexcCommonQuery end
abstract type MexcSpotPrivateQuery <: MexcCommonQuery end
abstract type MexcAPIError <: AbstractAPIsError end

"""
    MexcConfig <: AbstractAPIsConfig

Mexc client config. Transport options live in `request_options::RequestOptions`.

Required:
- `base_url::String`

Optional:
- `public_key::String`
- `secret_key::String`
- `account_name::String`
- `description::String`
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct MexcConfig <: AbstractAPIsConfig
    base_url::String = "https://api.mexc.com"
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

mutable struct MexcSpotClient <: MexcClient
    config::MexcConfig
    curl_client::CurlClient
    function MexcSpotClient(config::MexcConfig)
        new(config, CurlClient())
    end
    function MexcSpotClient(; kw...)
        MexcSpotClient(MexcConfig(; kw...))
    end
end

Base.isopen(c::MexcSpotClient) = isopen(c.curl_client)
Base.close(c::MexcSpotClient)  = close(c.curl_client)

mutable struct MexcFuturesClient <: MexcClient
    config::MexcConfig
    curl_client::CurlClient
    function MexcFuturesClient(config::MexcConfig)
        new(config, CurlClient())
    end
    function MexcFuturesClient(; kw...)
        MexcFuturesClient(MexcConfig(; kw...))
    end
end

Base.isopen(c::MexcFuturesClient) = isopen(c.curl_client)
Base.close(c::MexcFuturesClient)  = close(c.curl_client)

const public_spot_config    = MexcConfig(; base_url = "https://api.mexc.com")
const public_futures_config = MexcConfig(; base_url = "https://contract.mexc.com")

# ---------------------------------------------------------------------------

struct SpotData{D} <: MexcData
    code::Int
    msg::Maybe{String}
    timestamp::Maybe{NanoDate}
    data::D
    function SpotData{D}(
        code::Int,
        msg::Maybe{String},
        timestamp::Maybe{NanoDate},
        data::D,
    ) where {D}
        code == 0 || throw(ArgumentError("API response code must be zero"))
        new{D}(code, msg, timestamp, data)
    end
end

struct MexcSpotAPIError{T} <: MexcAPIError
    code::Int
    msg::String
    function MexcSpotAPIError(code::Int, msg::String)
        code != 0 || throw(ArgumentError("API response code must be non-zero"))
        new{code}(code, msg)
    end
end

CryptoExchangeAPIs.error_type(::MexcSpotClient) = MexcSpotAPIError

function Base.show(io::IO, e::MexcSpotAPIError)
    print(io, "code=\"", e.code, "\", msg=\"", e.msg, "\"")
end

struct FuturesData{D} <: MexcData
    success::Bool
    code::Int
    data::D
    function FuturesData{D}(
        success::Bool,
        code::Int,
        data::D,
    ) where {D}
        code == 0 || throw(ArgumentError("API response code must be zero"))
        new{D}(success, code, data)
    end
end

struct MexcFuturesAPIError{T} <: MexcAPIError
    code::Int
    success::Bool
    message::String
    function MexcFuturesAPIError(code::Int, success::Bool, message::String)
        code != 0 || throw(ArgumentError("API response code must be non-zero"))
        new{code}(code, success, message)
    end
end

CryptoExchangeAPIs.error_type(::MexcFuturesClient) = MexcFuturesAPIError

function Base.show(io::IO, e::MexcFuturesAPIError)
    print(io, "code=\"", e.code, "\", message=\"", e.message, "\"")
end

# --- signing ---------------------------------------------------------------

function CryptoExchangeAPIs.request_sign!(
    ::MexcClient,
    query::MexcPublicQuery,
    ::AbstractString
)
    query
end

function CryptoExchangeAPIs.request_sign!(
    client::MexcSpotClient,
    query::MexcSpotPrivateQuery,
    ::AbstractString
)
    if client.config.secret_key === nothing
        throw(ArgumentError("secret_key is required for Mexc private endpoints"))
    end
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    query_string = Serde.to_query(query)
    query.signature = bytes2hex(hmac_sha256(Vector{UInt8}(client.config.secret_key), query_string))
    return query
end

function CryptoExchangeAPIs.request_sign!(
    ::MexcClient,
    query::MexcAccessQuery,
    ::AbstractString
)
    query
end

# --- body/query ------------------------------------------------------------

CryptoExchangeAPIs.request_body(::MexcCommonQuery) = ""
CryptoExchangeAPIs.request_query(query::MexcCommonQuery) = Serde.to_query(query)

# --- headers ---------------------------------------------------------------

function CryptoExchangeAPIs.request_headers(
    ::MexcClient,
    ::MexcPublicQuery
)
    Pair{String,String}["Content-Type" => "application/json"]
end

function CryptoExchangeAPIs.request_headers(
    client::MexcSpotClient,
    ::MexcSpotPrivateQuery
)
    Pair{String,String}[
        "Content-Type" => "application/json",
        "X-MEXC-APIKEY" => client.config.public_key,
    ]
end

function CryptoExchangeAPIs.request_headers(
    client::MexcClient,
    ::MexcAccessQuery
)
    h = Pair{String,String}["Content-Type" => "application/json"]
    if client.config.public_key !== nothing
        push!(h, "X-MEXC-APIKEY" => client.config.public_key::String)
    end
    h
end

# --- rest ------------------------------------------------------------------

include("Utils.jl")

include("API/API.jl")
using .API

end
