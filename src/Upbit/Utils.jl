# Upbit/Utils

function Serde.deser(::Type{<:UpbitData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:UpbitData}, ::Type{<:Maybe{NanoDate}}, x::String)::NanoDate
    return NanoDate(x)
end

function Serde.deser(::Type{<:UpbitData}, ::Type{<:Maybe{Date}}, x::String)::Date
    return if occursin(r"^\d{4}-\d{2}-\d{2}$", x)
        Date(x, "yyyy-mm-dd")
    elseif occursin(r"^\d{8}$", x)
        Date(x, "yyyymmdd")
    else
        throw("Unrecognized data format in Upbit: $x")
    end
end

function Serde.deser(::Type{<:UpbitData}, ::Type{<:Maybe{Time}}, x::String)::Time
    return Time(x, "HHMMSS")
end

function Serde.SerQuery.ser_value(::Type{<:UpbitCommonQuery}, ::Val{:signature}, v::Any,)::Nothing
    return nothing
end

function Serde.SerQuery.ser_type(::Type{<:UpbitCommonQuery}, x::Vector{String})::String
    return join(x, ",")
end

function Serde.SerQuery.ser_type(::Type{<:UpbitCommonQuery}, x::DateTime)::String
    return Dates.format(x, "yyyy-mm-ddTHH:MM:SS")
end
