# Bybit/Utils

function Serde.deser(
    ::Type{<:AbstractAPIsData},
    ::Type{<:Maybe{NanoDate}},
    x::Int64,
)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(
    ::Type{<:AbstractAPIsData},
    ::Type{<:Maybe{NanoDate}},
    x::String,
)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.deser(
    ::Type{<:BybitAPIError},
    ::Type{<:Maybe{NanoDate}},
    x::Int64,
)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.ser_ignore_field(::Type{<:BybitCommonQuery}, ::Val{:timestamp})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:BybitCommonQuery}, ::Val{:api_key})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:BybitCommonQuery}, ::Val{:recv_window})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:BybitCommonQuery}, ::Val{:sign})::Bool
    return true
end

function Serde.SerQuery.ser_name(::Type{<:BybitCommonQuery}, ::Val{:_end})::String
    return "end"
end

function Serde.SerQuery.ser_type(::Type{<:BybitCommonQuery}, dt::DateTime)::Int64
    return round(Int64, 1000 * datetime2unix(dt))
end
