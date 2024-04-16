module Gateio

export GateioCommonQuery,
    GateioPublicQuery,
    GateioAccessQuery,
    GateioPrivateQuery,
    GateioAPIError,
    GateioClient,
    GateioData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoAPIs
import ..CryptoAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type GateioData <: AbstractAPIsData end
abstract type GateioCommonQuery  <: AbstractAPIsQuery end
abstract type GateioPublicQuery  <: GateioCommonQuery end
abstract type GateioAccessQuery  <: GateioCommonQuery end
abstract type GateioPrivateQuery <: GateioCommonQuery end

"""
    GateioClient <: AbstractAPIsClient

Client info.

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
Base.@kwdef struct GateioClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    GateioAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `label::String`: Error label.
- `message::String`: Error message.
"""
struct GateioAPIError{T} <: AbstractAPIsError
    label::String
    message::String

    function GateioAPIError(label::String, x...)
        return new{Symbol(label)}(label, x...)
    end
end

CryptoAPIs.error_type(::GateioClient) = GateioAPIError

function Base.show(io::IO, e::GateioAPIError)
    return print(io, "label = ", "\"", e.label, "\"", ", ", "msg = ", "\"", e.message, "\"")
end

function CryptoAPIs.request_sign!(::GateioClient, query::Q, ::String)::Q where {Q<:GateioPublicQuery}
    return query
end

function gen_sign(method::String, query::Q, url::String)::String where {Q<:GateioPrivateQuery}
    t = string(round(Int64, datetime2unix(query.signTimestamp)))
    query_string::String = Serde.to_query(query)
    hashed_payload = hexdigest("sha512", "")
    sign = join([method, url, query_string, hashed_payload, t], "\n")
    return sign
end

function CryptoAPIs.request_sign!(client::GateioClient, query::Q, endpoint::String)::Q where {Q<:GateioPrivateQuery}
    query.signTimestamp = Dates.now(UTC)
    query.signature = nothing
    endpoint = "/" * endpoint
    query.signature = hexdigest("sha512", client.secret_key, gen_sign("GET", query, endpoint))
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:GateioCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:GateioCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::GateioClient, ::GateioPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json"
    ]
end

function CryptoAPIs.request_headers(client::GateioClient, query::GateioPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "KEY"          => client.public_key,
        "SIGN"         => query.signature,
        "Timestamp"    => string(round(Int64, datetime2unix(query.signTimestamp))),
        "Content-Type" => "application/json",
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

include("Futures/Futures.jl")
using .Futures

end