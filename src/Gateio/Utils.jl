# Gateio/Utils

function Serde.deser(::Type{<:GateioData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e9)
end

function Serde.deser(::Type{<:GateioData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e9)
end

function Serde.ser_ignore_field(::Type{<:GateioCommonQuery}, ::Val{:signTimestamp})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:GateioCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:GateioCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, datetime2unix(x))
end
