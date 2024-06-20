module CoinMarketCap

export CoinMarketCapCommonQuery,
    CoinMarketCapPublicQuery,
    CoinMarketCapAccessQuery,
    CoinMarketCapPrivateQuery,
    CoinMarketCapAPIError,
    CoinMarketCapClient,
    CoinMarketCapData


using Serde
using Dates, NanoDates, Base64, Nettle

using ..CryptoAPIs
using ..CryptoAPIs: Maybe,  AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type CoinMarketCapData <: AbstractAPIsData end
abstract type CoinMarketCapCommonQuery <: AbstractAPIsQuery end
abstract type CoinMarketCapPublicQuery <: CoinMarketCapCommonQuery end
abstract type CoinMarketCapAccessQuery <: CoinMarketCapCommonQuery end
abstract type CoinMarketCapPrivateQuery <: CoinMarketCapCommonQuery end

"""
    Data{D} <: AbstractAPIsData

## Required fields
- `id::Int64`: Return id.
- `method::String`: Return method endpoint.
- `code::String`: Return code.
- `result::D`: Request result data.
"""
struct Data{D<:AbstractAPIsData} <: AbstractAPIsData
    id::Int64
    method::String
    code::String
    result::D
end


"""
    CoinMarketCapClient <: AbstractAPIsClient

Client info.

## Required fields
- `base_url::String`: Base URL for the client. 
- `secret_key::String`: Secret key for authentication.

## Optional fields
- `public_key::String`: Public key for authentication.
- `interface::String`: Interface for the client.
- `proxy::String`: Proxy information for the client.
- `account_name::String`: Account name associated with the client.
- `description::String`: Description of the client.
"""
Base.@kwdef struct CoinMarketCapClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    CoinMarketCapAPIError{T} <: AbstractAPIsError

Exception thrown when an API method fails with code `T`.

## Required fields
- `code::Int64`: Error code.
- `message::String`: Error message.

"""
struct CoinMarketCapAPIError{T} <: AbstractAPIsError
    code::Int64
    message::Maybe{String}

    function CoinMarketCapAPIError(code::Int64, x...)
        return new{code}(code, x...)
    end
end

CryptoAPIs.error_type(::CoinMarketCapClient) = CoinMarketCapAPIError

function Base.show(io::IO, e::CoinMarketCapAPIError)
    return print(io, "code = ", "\"", e.code, "\"", ", ", "msg = ", "\"", e.message, "\"", ", ")
end

function CryptoAPIs.request_sign!(::CoinMarketCapClient, query::Q, ::String)::Q where {Q<:CoinMarketCapPublicQuery}
    return query
end

function CryptoAPIs.request_body(::Q)::String where {Q<:CoinMarketCapCommonQuery}
    return ""
end

function CryptoAPIs.request_query(query::Q)::String where {Q<:CoinMarketCapCommonQuery}
    return Serde.to_query(query)
end

function CryptoAPIs.request_headers(client::CoinMarketCapClient, ::CoinMarketCapPublicQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
        "X-CMC_PRO_API_KEY" => client.secret_key,
    ]
end

function CryptoAPIs.request_headers(client::CoinMarketCapClient, ::CoinMarketCapPrivateQuery)::Vector{Pair{String,String}}
    return Pair{String,String}[
        "Content-Type" => "application/json",
       "X-CMC_PRO_API_KEY" => client.secret_key,
    ]
end


include("Utils.jl")
include("Errors.jl")

include("Spot/Spot.jl")
using .Spot

end
