module Huobi

export HuobiCommonQuery,
    HuobiPublicQuery,
    HuobiAccessQuery,
    HuobiPrivateQuery,
    HuobiAPIError,
    HuobiClient,
    HuobiData

using Serde
using Dates, NanoDates, TimeZones, Base64, Nettle

using ..CryptoExchangeAPIs
import ..CryptoExchangeAPIs: Maybe, AbstractAPIsError, AbstractAPIsData, AbstractAPIsQuery, AbstractAPIsClient

abstract type HuobiData <: AbstractAPIsData end
abstract type HuobiCommonQuery  <: AbstractAPIsQuery end
abstract type HuobiPublicQuery  <: HuobiCommonQuery end
abstract type HuobiAccessQuery  <: HuobiCommonQuery end
abstract type HuobiPrivateQuery <: HuobiCommonQuery end

@enum Status begin
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
    status::Maybe{Status}
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
    status::Status
    ch::String
    ts::NanoDate
    tick::D
end

"""
    HuobiClient <: AbstractAPIsClient

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
Base.@kwdef struct HuobiClient <: AbstractAPIsClient
    base_url::String
    public_key::Maybe{String} = nothing
    secret_key::Maybe{String} = nothing
    interface::Maybe{String} = nothing
    proxy::Maybe{String} = nothing
    account_name::Maybe{String} = nothing
    description::Maybe{String} = nothing
end

"""
    public_client = HuobiClient(; base_url = "https://api.huobi.pro")
"""
const public_client = HuobiClient(; base_url = "https://api.huobi.pro")

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

function CryptoExchangeAPIs.request_sign!(client::HuobiClient, query::Q, endpoint::String)::Nothing where {Q<:HuobiPrivateQuery}
    query.AccessKeyId = client.public_key
    query.Timestamp = now(UTC)
    query.SignatureMethod = "HmacSHA256"
    query.SignatureVersion  = "2"
    query.Signature = nothing
    body::String = Serde.to_query(query)
    endpoint = string("/", endpoint)
    host = last(split(client.base_url, "//"))
    salt = join(["GET", host, endpoint, body], "\n")
    query.Signature = Base64.base64encode(digest("sha256", client.secret_key, salt))
    return nothing
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

end
