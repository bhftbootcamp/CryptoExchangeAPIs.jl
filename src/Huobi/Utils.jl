# Houbi/Utils

function Serde.deser(::Type{<:Union{Data,DataTick}}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:Union{Data,DataTick}}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.deser(::Type{<:HuobiData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:HuobiData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.custom_name(::Type{<:HuobiData}, ::Val{x}) where {x}
    return replace(string(x), "_" => "-")
end

function Serde.custom_name(::Type{<:HuobiAPIError}, ::Val{x}) where {x}
    return replace(string(x), "_" => "-")
end

function Serde.SerQuery.ser_value(::Type{<:HuobiCommonQuery}, ::Val{:Timestamp}, v::Any)::String
    return string(Dates.format(v, "yyyy-mm-ddTHH:MM:SS"))
end

function Serde.SerQuery.ser_name(::Type{<:HuobiCommonQuery}, ::Val{:start_time})::String 
    return "start-time"
end

function Serde.SerQuery.ser_name(::Type{<:HuobiCommonQuery}, ::Val{:end_time})::String 
    return "end-time"
end

function Serde.SerQuery.ser_type(::Type{<:HuobiCommonQuery}, dt::D)::Int64 where {D<:DateTime}
    return round(Int64, datetime2unix(dt))
end
