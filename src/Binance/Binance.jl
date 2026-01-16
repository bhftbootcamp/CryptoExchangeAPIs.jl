module Binance

export BinanceCommonQuery,
       BinancePublicQuery,
       BinanceAccessQuery,
       BinancePrivateQuery,
       BinanceAPIError,
       BinanceClient,
       BinanceConfig,
       BinanceData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle, EasyCurl
using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe,
    AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery,
    AbstractAPIsClient, AbstractAPIsConfig, RequestOptions

# ---------------------------------------------------------------------------

abstract type BinanceData <: AbstractAPIsData end
abstract type BinanceCommonQuery  <: AbstractAPIsQuery end
abstract type BinancePublicQuery  <: BinanceCommonQuery end
abstract type BinanceAccessQuery  <: BinanceCommonQuery end
abstract type BinancePrivateQuery <: BinanceCommonQuery end

"""
    BinanceConfig <: AbstractAPIsConfig

Binance client config. Transport options live in `request_options::RequestOptions`.

Required:
- `base_url::String`

Optional:
- `public_key::String`
- `secret_key::String`
- `account_name::String`
- `description::String`
- `request_options::RequestOptions` (interface/proxy/timeouts)
"""
Base.@kwdef struct BinanceConfig <: AbstractAPIsConfig
    base_url::String = "https://api.binance.com"
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
    request_options::RequestOptions = RequestOptions()
end

mutable struct BinanceClient <: AbstractAPIsClient
    config::BinanceConfig
    curl_client::CurlClient
    function BinanceClient(config::BinanceConfig)
        new(config, CurlClient())
    end
    function BinanceClient(; kw...)
        BinanceClient(BinanceConfig(; kw...))
    end
end

Base.isopen(c::BinanceClient) = isopen(c.curl_client)
Base.close(c::BinanceClient)  = close(c.curl_client)

const public_config      = BinanceConfig(; base_url = "https://api.binance.com")
const public_fapi_config = BinanceConfig(; base_url = "https://fapi.binance.com")
const public_dapi_config = BinanceConfig(; base_url = "https://dapi.binance.com")
const public_bapi_config = BinanceConfig(; base_url = "https://www.binance.com")

# ---------------------------------------------------------------------------

struct BinanceAPIError{T} <: AbstractAPIsError
    code::Int64
    type::Maybe{String}
    msg::Maybe{String}
    function BinanceAPIError(code::Int64, x...)
        iszero(code) && throw(ArgumentError("API response code must be non-zero"))
        new{code}(code, x...)
    end
end

CryptoExchangeAPIs.error_type(::BinanceClient) = BinanceAPIError

function Base.show(io::IO, e::BinanceAPIError)
    print(io, "code=\"", e.code, "\", msg=\"", e.msg, "\"")
end

# --- signing ---------------------------------------------------------------

function CryptoExchangeAPIs.request_sign!(
    ::BinanceClient,
    query::Q,
    ::AbstractString
) where {Q<:BinancePublicQuery}
    query
end

function CryptoExchangeAPIs.request_sign!(
    client::BinanceClient,
    query::Q,
    ::AbstractString
) where {Q<:BinancePrivateQuery}
    if client.config.secret_key === nothing
        throw(ArgumentError("secret_key is required for Binance private endpoints"))
    end
    query.timestamp = Dates.now(UTC)
    query.signature = nothing
    str_query = Serde.to_query(query)
    query.signature = hexdigest("sha256", client.config.secret_key::String, str_query)
    query
end

function CryptoExchangeAPIs.request_sign!(
    ::BinanceClient,
    query::Q,
    ::AbstractString
) where {Q<:BinanceAccessQuery}
    query
end

# --- body/query ------------------------------------------------------------

CryptoExchangeAPIs.request_body(::Q) where {Q<:BinanceCommonQuery} = ""
CryptoExchangeAPIs.request_query(query::Q) where {Q<:BinanceCommonQuery} = Serde.to_query(query)

# --- headers ---------------------------------------------------------------

function CryptoExchangeAPIs.request_headers(
    ::BinanceClient,
    ::BinancePublicQuery
)
    Pair{String,String}["Content-Type" => "application/json"]
end

function CryptoExchangeAPIs.request_headers(
    client::BinanceClient,
    ::BinancePrivateQuery
)
    h = Pair{String,String}["Content-Type" => "application/json"]
    if client.config.public_key !== nothing
        push!(h, "X-MBX-APIKEY" => client.config.public_key::String)
    end
    h
end

function CryptoExchangeAPIs.request_headers(
    client::BinanceClient,
    ::BinanceAccessQuery
)
    h = Pair{String,String}["Content-Type" => "application/json"]
    if client.config.public_key !== nothing
        push!(h, "X-MBX-APIKEY" => client.config.public_key::String)
    end
    h
end

# --- rest ------------------------------------------------------------------

include("Utils.jl")
include("Errors.jl")

include("API/API.jl");     using .API
include("SAPI/SAPI.jl");   using .SAPI
include("FAPI/FAPI.jl");   using .FAPI
include("DAPI/DAPI.jl");   using .DAPI
include("BAPI/BAPI.jl");   using .BAPI
include("Futures/Futures.jl"); using .Futures

end
