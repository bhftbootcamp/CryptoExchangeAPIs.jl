module CryptoExchangeAPIs

export cex_query, cex_client, cex_result

using EasyCurl, Serde
using Dates, NanoDates, TimeZones

abstract type AbstractAPIsQuery end
abstract type AbstractAPIsConfig end
abstract type AbstractAPIsClient end
abstract type AbstractAPIsData end
abstract type AbstractAPIsError <: Exception end

const Maybe{T} = Union{Nothing,T}

function request_headers end
function request_body end
function request_query end
function request_sign! end
function error_type end
function prepare_json! end

function isretriable end
function retry_timeout end
function retry_maxcount end

struct APIsRequest{T}
    method::AbstractString
    endpoint::AbstractString
    query::Q where {Q<:AbstractAPIsQuery}
    num_calls::Ref{Int64}

    function APIsRequest{T}(
        method::AbstractString,
        endpoint::AbstractString,
        query::Q where {Q<:AbstractAPIsQuery},
    ) where {T}
        return new{T}(method, endpoint, query, Ref{Int64}(0))
    end
end

"""
    APIsHeaders

Headers of the API resonse.

## Optional fields
- `date::String = nothing`: Response date.
- `retry_after::Float64 = 1.0`: Number of retries.
"""
struct APIsHeaders
    date::Maybe{String}
    retry_after::Maybe{Float64}

    function APIsHeaders(date::Maybe{String}, retry_after::Maybe{Float64})
        return new(date, isnothing(retry_after) ? 1.0 : retry_after)
    end
end

@serde_kebab_case(APIsHeaders)

"""
    APIsResponse

API response status.

## fields
- `headers::APIsHeaders`: Headers of the API resonse.
- `status_code::Int64`: API response status code.
"""
struct APIsResponse
    headers::APIsHeaders
    status_code::Int64
end

"""
    APIsResult{T}

Result `T` of the API method .

## Required fields
- `config::AbstractAPIsClient`: Request config.
- `query::APIsRequest`: Request parameter query.
- `result::T`: Result of the API request method.

## Optional fields
- `response::APIsResponse`: API response.
"""
struct APIsResult{T}
    config::AbstractAPIsConfig
    query::APIsRequest
    response::Maybe{APIsResponse}
    result::T
end

struct APIsUndefError <: AbstractAPIsError
    e::Exception
    message::String
end

function iserror(x::APIsResult{T})::Bool where {T}
    return T <: Exception
end

"""
    cex_config(x::APIsResult)

Getter function for obtaining information about the request config.
"""
function cex_config(x::APIsResult)
    return x.config
end

"""
    cex_result(x::APIsResult)

Getter function for obtaining the response result.
"""
function cex_result(x::APIsResult)
    return x.result
end

"""
    cex_query(x::APIsResult)

Getter function for obtaining query of the API request.
"""
function cex_query(x::APIsResult)
    return x.query
end

function Base.show(io::IO, x::APIsResult{E}) where {E<:Exception}
    return print(
        io,
        "method = ",
        "\"",
        x.query.method,
        "\"",
        ", base_url = ",
        "\"",
        x.config.base_url,
        "\"",
        ", endpoint = ",
        "\"",
        x.query.endpoint,
        "\"",
        ", query = ",
        "\"",
        request_query(x.query.query),
        "\"",
        ", error = ",
        "\"",
        E,
        "(",
        x.result,
        ")",
        "\"",
    )
end

include("Interface.jl")
include("Aevo/Aevo.jl")
include("Binance/Binance.jl")
include("Bitfinex/Bitfinex.jl")
include("Bithumb/Bithumb.jl")
include("Bybit/Bybit.jl")
include("Coinbase/Coinbase.jl")
include("Cryptocom/Cryptocom.jl")
include("Deribit/Deribit.jl")
include("Gateio/Gateio.jl")
include("Huobi/Huobi.jl")
include("Okex/Okex.jl")
include("Poloniex/Poloniex.jl")
include("Kraken/Kraken.jl")
include("Kucoin/Kucoin.jl")
include("Upbit/Upbit.jl")

end
