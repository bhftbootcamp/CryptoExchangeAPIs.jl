# Bitfinex/Utils

function Serde.deser(::Type{<:BitfinexData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:BitfinexData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.SerQuery.ser_ignore_field(::Type{<:BitfinexCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.SerQuery.ser_ignore_field(::Type{<:BitfinexCommonQuery}, ::Val{:nonce})::Bool
    return true
end

function Serde.SerQuery.ser_name(::Type{<:BitfinexCommonQuery}, ::Val{:_end})::String
    return "end"
end

function Serde.ser_type(::Type{<:BitfinexCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, 1000 * datetime2unix(x))
end
