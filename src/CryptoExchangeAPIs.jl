module CryptoExchangeAPIs

export cex_config, cex_result, cex_query, cex_raw_text, cex_status, cex_headers, cex_latency,
       APIsRequest, APIsHeaders, APIsResponse, APIsResult, APIsUndefError, APIsConfig, RequestOptions,
       AbstractAPIsQuery, AbstractAPIsConfig, AbstractAPIsClient, AbstractAPIsData, AbstractAPIsError

using EasyCurl, Serde
using Dates, NanoDates, TimeZones
using Random

abstract type AbstractAPIsQuery  end
abstract type AbstractAPIsConfig end
abstract type AbstractAPIsClient end
abstract type AbstractAPIsData   end
abstract type AbstractAPIsError <: Exception end

const Maybe{T} = Union{Nothing,T}

Base.@kwdef struct RequestOptions
    interface::Maybe{String}    = nothing
    proxy::Maybe{String}        = nothing
    read_timeout::Maybe{Int}    = nothing
    connect_timeout::Maybe{Int} = nothing
end

Base.@kwdef mutable struct APIsConfig <: AbstractAPIsConfig
    base_url::String
    request_options::RequestOptions = RequestOptions()
end

function request_headers end
function request_body end
function request_query end
function request_sign! end
function error_type end
function prepare_json! end

function isretriable end
function retry_timeout end
function retry_maxcount end

struct APIsRequest{T,Q<:AbstractAPIsQuery}
    method::AbstractString
    endpoint::AbstractString
    query::Q
    num_calls::Base.RefValue{Int64}
    function APIsRequest{T}(method::AbstractString, endpoint::AbstractString, query::Q) where {T,Q<:AbstractAPIsQuery}
        new{T,Q}(method, endpoint, query, Ref{Int64}(0))
    end
end

struct APIsHeaders
    date::Maybe{String}
    retry_after::Float64
    function APIsHeaders(date::Maybe{String}, retry_after::Maybe{Float64})
        new(date, isnothing(retry_after) ? 1.0 : retry_after::Float64)
    end
end
@serde_kebab_case(APIsHeaders)

struct APIsResponse
    headers::APIsHeaders
    status_code::Int
    raw_text::String
    latency_ms::Float64
end

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

iserror(x::APIsResult) = x.result isa Exception

cex_config(x::APIsResult) = x.config
cex_result(x::APIsResult) = x.result
cex_query(x::APIsResult)  = x.query
function cex_raw_text(x::APIsResult)
    x.response === nothing && return nothing
    x.response.raw_text
end
function cex_status(x::APIsResult)
    x.response === nothing && return nothing
    x.response.status_code
end
function cex_headers(x::APIsResult)
    x.response === nothing && return nothing
    x.response.headers
end
function cex_latency(x::APIsResult)
    x.response === nothing && return nothing
    x.response.latency_ms
end

function Base.show(io::IO, x::APIsResult{E}) where {E<:Exception}
    resp = x.response
    print(io,
        "method=\"", x.query.method,
        "\", base_url=\"", x.config.base_url,
        "\", endpoint=\"", x.query.endpoint,
        "\", query=\"", request_query(x.query.query),
        "\", status=", isnothing(resp) ? "?" : string(resp.status_code),
        ", error=", string(E), "(",
    )
    show(io, x.result)
    print(io, ")")
end

function log_msg(client::AbstractAPIsClient, query::APIsRequest)
    return (
        base_url  = client.config.base_url,
        method    = query.method,
        endpoint  = query.endpoint,
        query     = Serde.to_json(query.query),
        num_calls = query.num_calls[],
    )
end

const RETRY_BASE = 1.0
const RETRY_MULTIPLIER = 2.0
const RETRY_MAX_RETRIES = 3
const RETRY_JITTER_FRAC = 0.2

function compute_backoff(attempt::Int)
    backoff = RETRY_BASE * (RETRY_MULTIPLIER)^(attempt - 1)
    jitter = RETRY_JITTER_FRAC * backoff * (0.5 + rand())
    backoff + jitter
end

isretriable(::Exception) = false
isretriable(::AbstractCurlError) = true
isretriable(e::APIsResult{<:Exception}) = isretriable(e.result)

retry_timeout(::Exception) = 1.0
retry_maxcount(::Exception) = RETRY_MAX_RETRIES

function perform_request(client::AbstractAPIsClient, query::APIsRequest)
    request_sign!(client, query.query, query.endpoint)
    t0 = time_ns()
    ro = client.config.request_options
    req = http_request(
        client.curl_client,
        query.method,
        curl_joinurl(client.config.base_url, query.endpoint);
        headers = request_headers(client, query.query),
        body = request_body(query.query),
        query = request_query(query.query),
        interface = ro.interface,
        proxy = ro.proxy,
        read_timeout = something(ro.read_timeout, 60),
        connect_timeout = something(ro.connect_timeout, 60),
        status_exception = false,
    )
    t1 = time_ns()
    raw_text = String(view(req.body, 1:length(req.body)))
    latency_ms = (t1 - t0) / 1.0e6
    return req, raw_text, latency_ms
end

function prepare_json!(::Type{T}, json) where {T}
    json
end

function (query::APIsRequest{T})(client::AbstractAPIsClient)::APIsResult where {T}
    fetch = try
        query.num_calls[] += 1
        response, raw_text, latency_ms = perform_request(client, query)

        headers = try
            Serde.deser(APIsHeaders, Dict(response.headers))
        catch
            APIsHeaders(nothing, 1.0)
        end

        payload_json = try
            Serde.parse_json(response.body)
        catch ex
            err = APIsUndefError(ex, raw_text)
            throw(APIsResult{typeof(err)}(client.config, query,
                  APIsResponse(headers, response.status, raw_text, latency_ms),
                  err))
        end

        payload_data = try
            Serde.deser(T, prepare_json!(T, payload_json))
        catch ex
            err = try
                Serde.deser_json(error_type(client), response.body)
            catch
                APIsUndefError(ex, raw_text)
            end
            throw(APIsResult{typeof(err)}(client.config, query,
                  APIsResponse(headers, response.status, raw_text, latency_ms),
                  err))
        end

        APIsResult{T}(client.config, query,
            APIsResponse(headers, response.status, raw_text, latency_ms),
            payload_data)

    catch ex
        err = ex isa APIsResult ? ex :
              APIsResult{typeof(ex)}(client.config, query, nothing, ex)

        attempts = query.num_calls[] - 1
        should_retry = isretriable(err) && (attempts < RETRY_MAX_RETRIES)

        if should_retry
            backoff = compute_backoff(attempts + 1)
            @warn err log_msg(client, query)... attempt = attempts + 1 backoff = backoff
            sleep(backoff)
            query(client)
        else
            err
        end
    end

    return iserror(fetch) ? throw(fetch) : fetch
end

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
include("Hyperliquid/Hyperliquid.jl")
include("Okx/Okx.jl")
include("Poloniex/Poloniex.jl")
include("Kraken/Kraken.jl")
include("Kucoin/Kucoin.jl")
include("Upbit/Upbit.jl")

end
