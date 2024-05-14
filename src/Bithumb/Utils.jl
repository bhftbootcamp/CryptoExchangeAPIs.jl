# Bithumb/Utils

function Serde.deser(::Type{<:BithumbData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:BithumbData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.deser(::Type{Data}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.deser(::Type{Data}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.ser_ignore_field(::Type{<:BithumbCommonQuery}, ::Val{:nonce})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:BithumbCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:BithumbCommonQuery}, dt::DateTime)::Int64
    return round(Int64, 1000 * datetime2unix(dt))
end
