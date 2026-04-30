# Gateio/Utils

function Serde.deser(::Type{<:GateioData}, ::Type{<:Maybe{NanoDate}}, x::Int)
    return iszero(x) ? nothing : unixnanos2nanodate(x * 1e9)
end

function Serde.deser(::Type{<:GateioData}, ::Type{<:Maybe{NanoDate}}, s::AbstractString)
    x = parse(Int, s)
    return iszero(x) ? nothing : unixnanos2nanodate(x * 1e9)
end

Serde.ser_ignore_field(::Type{<:GateioCommonQuery}, ::Val{:signTimestamp}) = true

Serde.ser_ignore_field(::Type{<:GateioCommonQuery}, ::Val{:signature}) = true

function Serde.SerQuery.ser_type(::Type{<:GateioCommonQuery}, x::DateTime)
    return round(Int, datetime2unix(x))
end
