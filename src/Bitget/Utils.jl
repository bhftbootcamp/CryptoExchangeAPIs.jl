Serde.SerQuery.ser_value(::Type{<:BitgetCommonQuery}, ::Val{:timestamp}, v) = nothing
Serde.SerQuery.ser_value(::Type{<:BitgetCommonQuery}, ::Val{:sign}, v) = nothing

Serde.SerJson.ser_value(::Type{<:BitgetCommonQuery}, ::Val{:timestamp}, v) = nothing
Serde.SerJson.ser_value(::Type{<:BitgetCommonQuery}, ::Val{:sign}, v) = nothing

Serde.SerQuery.ser_type(::Type{<:BitgetCommonQuery}, dt::DateTime) = round(Int, 1000 * datetime2unix(dt))
Serde.SerJson.ser_type(::Type{<:BitgetCommonQuery}, dt::DateTime) = round(Int, 1000 * datetime2unix(dt))

Serde.isempty(::Type{<:BitgetData}, x::String) = isempty(x)

function Serde.deser(
    ::Type{<:BitgetData},
    ::Type{NanoDate},
    x::Int64,
)
    return x in (-1, 0) ? nothing : unixnanos2nanodate(x * 10^6)
end

function Serde.deser(
    ::Type{<:BitgetData},
    ::Type{NanoDate},
    s::String,
)
    x = parse(Int, s)
    return x in (-1, 0) ? nothing : unixnanos2nanodate(x * 10^6)
end
