# Kraken/Utils

Serde.isempty(::Type{<:KrakenData}, x::String) = isempty(x)

function Serde.deser(::Type{<:KrakenData}, ::Type{<:Maybe{NanoDate}}, x::Real)::NanoDate
    return unixnanos2nanodate(x * 1e9)
end

Serde.deser(::Type{<:KrakenData}, ::Type{Date}, x::AbstractString) = Date(x, "yyyy-mm-dd")

function Serde.deser(::Type{<:KrakenData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return NanoDate(DateTime(x, "yyyy-mm-ddTHH:MM:SS.ssszzzz"))
end

function Serde.ser_ignore_field(::Type{<:KrakenCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:KrakenCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, 1000 * datetime2unix(x))
end
