# Coinbase/Utils

function Serde.deser(::Type{<:CoinbaseData}, ::Type{<:NanoDate}, x::AbstractString)::NanoDate
    return NanoDate(endswith(x, "Z") ? chop(x) : x)
end

function Serde.deser(::Type{<:CoinbaseData}, ::Type{<:NanoDate}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e9)
end

function Serde.ser_ignore_field(::Type{<:CoinbaseCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:CoinbaseCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:CoinbaseCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.SerQuery.ser_name(::Type{<:CoinbaseCommonQuery}, ::Val{:_end})::String
    return "end"
end

function Serde.SerQuery.ser_type(::Type{<:CoinbaseCommonQuery}, x::D)::String where {D<:DateTime}
    return Dates.format(x, "yyyy-mm-ddTHH:MM:SS")
end
