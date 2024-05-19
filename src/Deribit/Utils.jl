# Deribit/Utils

function Serde.deser(::Type{<:DeribitData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:DeribitData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return NanoDate(x)
end

function Serde.deser(::Type{<:DeribitData},::Type{<:Maybe{Vector{NanoDate}}}, x::Vector{Any})::Maybe{Vector{NanoDate}}
    return unixnanos2nanodate.(x * 1e6)
end

function Serde.deser(::Type{<:Data}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e3)
end

function Serde.deser(::Type{<:Data}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(x * 1e3)
end

function Serde.ser_ignore_field(::Type{<:DeribitCommonQuery}, ::Val{:authorization})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:DeribitCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:DeribitCommonQuery}, ::Val{:nonce})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:DeribitCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, 1000 * datetime2unix(x))
end
