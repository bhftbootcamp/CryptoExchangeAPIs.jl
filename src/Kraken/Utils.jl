# Kraken/Utils

function Serde.deser(::Type{<:KrakenData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e9)
end

function Serde.deser(::Type{<:KrakenData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return NanoDate(DateTime(x, "yyyy-mm-ddTHH:MM:SS.ssszzzz"))
end

function Serde.ser_ignore_field(::Type{<:KrakenCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:KrakenCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, datetime2unix(x))
end
