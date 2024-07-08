# Aevo/Utils

function Serde.deser(::Type{<:AevoData}, ::Type{<:Maybe{NanoDate}}, x::String)::NanoDate
    return unixnanos2nanodate(parse(Int64, x))
end

function Serde.SerQuery.ser_type(::Type{<:AevoCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, 1000 * datetime2unix(x))
end
