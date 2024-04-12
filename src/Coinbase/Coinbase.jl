module Coinbase

export CoinbaseCommonQuery,
    CoinbasePublicQuery,
    CoinbaseAccessQuery,
    CoinbasePrivateQuery,
    CoinbaseAPIError,
    CoinbaseClient,
    CoinbaseData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoAPIs
import ..CryptoAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type CoinbaseData <: AbstractAPIsData end
abstract type CoinbaseCommonQuery  <: AbstractAPIsQuery end
abstract type CoinbasePublicQuery  <: CoinbaseCommonQuery end
abstract type CoinbaseAccessQuery  <: CoinbaseCommonQuery end
abstract type CoinbasePrivateQuery <: CoinbaseCommonQuery end

"""
    CoinbaseClient <: AbstractAPIsClient

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
Base.@kwdef struct CoinbaseClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    passphrase::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    CoinbaseAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `msg::String`: Error message.
"""
struct CoinbaseAPIError{T} <: AbstractAPIsError
    message::String

    function CoinbaseAPIError(message::String, x...)
        return new{Symbol(message)}(message, x...)
    end
end

CryptoAPIs.error_type(::CoinbaseClient) = CoinbaseAPIError

function Base.show(io::IO, e::CoinbaseAPIError)
    return print(io, "message = ", "\"", e.message)
end

function CryptoAPIs.request_sign!(::CoinbaseClient, query::Q, ::String)::Q where {Q<:CoinbasePublicQuery}
    return query
end

function CryptoAPIs.request_sign!(client::CoinbaseClient, query::Q, endpoint::String)::Q where {Q<:CoinbasePrivateQuery}
    query.timestamp = string(round(Int64, datetime2unix(Dates.now(UTC))))
    query.signature = nothing
    str_query = isempty(Serde.to_query(query)) ? "" : "?" * Serde.to_query(query)
    endpoint = "/" * endpoint * str_query
    message = join([query.timestamp, "GET", endpoint, ""])
    query.signature = base64encode(digest("sha256", base64decode(client.secret_key), message))
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:CoinbaseCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:CoinbaseCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::CoinbaseClient, ::CoinbasePublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "User-Agent" => "CryptoAPIs.Coinbase",
    ]
end

function CryptoAPIs.request_headers(client::CoinbaseClient, query::CoinbasePrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "CB-ACCESS-KEY" => client.public_key,
        "CB-ACCESS-SIGN" => query.signature,
        "CB-ACCESS-TIMESTAMP" => query.timestamp,
        "CB-ACCESS-PASSPHRASE" => client.passphrase,
    ]
end

include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
