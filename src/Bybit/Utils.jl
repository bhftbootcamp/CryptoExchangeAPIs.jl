# Bybit/Utils

function Serde.deser(
    ::Type{<:AbstractAPIsData},
    ::Type{<:DateTime},
    x::String,
)::DateTime
    return unix2datetime(parse(Int64, x) * 1e-3)
end

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

function Serde.SerQuery.ser_value(::Type{<:BybitCommonQuery}, ::Val{:timestamp}, v::Any)::Nothing
    return nothing
end

function Serde.SerQuery.ser_value(::Type{<:BybitCommonQuery}, ::Val{:api_key}, v::Any)::Nothing
    return nothing
end

function Serde.SerQuery.ser_value(::Type{<:BybitCommonQuery}, ::Val{:recv_window}, v::Any)::Nothing
    return nothing
end

function Serde.SerQuery.ser_value(::Type{<:BybitCommonQuery}, ::Val{:sign}, v::Any)::Nothing
    return nothing
end

function Serde.SerQuery.ser_name(::Type{<:BybitCommonQuery}, ::Val{:_end})::String
    return "end"
end

function Serde.SerQuery.ser_type(::Type{<:BybitCommonQuery}, dt::DateTime)::Int64
    return time2unix(dt)
end
