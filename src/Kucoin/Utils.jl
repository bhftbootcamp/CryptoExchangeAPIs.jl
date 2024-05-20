# Kucoin/Utils

function Serde.deser(::Type{<:KucoinData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:KucoinData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e9)
end

function Serde.ser_ignore_field(::Type{<:KucoinCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:KucoinCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:KucoinCommonQuery}, ::Val{:passphrase})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:KucoinCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, datetime2unix(x))
end

function Serde.SerQuery.ser_type(::Type{<:KucoinCommonQuery}, x::D)::Int64 where {D<:NanoDate}
    return round(Int64, nanodate2unixmillis(x))
end
