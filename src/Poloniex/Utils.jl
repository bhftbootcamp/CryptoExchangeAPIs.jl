# Poloniex/Utils

function Serde.deser(::Type{<:PoloniexData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:PoloniexData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.deser(::Type{<:PoloniexAPIError}, data::Vector{Any})
    return PoloniexAPIError(-1, "Undefined symbol")
end

function Serde.ser_ignore_field(::Type{<:PoloniexCommonQuery}, ::Val{:signature})::Bool
    return true
end

function Serde.ser_ignore_field(::Type{<:PoloniexCommonQuery}, ::Val{:signTimestamp})::Bool
    return true
end

function Serde.SerQuery.ser_type(::Type{<:PoloniexCommonQuery}, dt::D)::Int64 where {D<:DateTime}
    return round(Int64, 1000 * datetime2unix(dt))
end

function Serde.SerQuery.ser_type(::Type{<:PoloniexCommonQuery}, x::Vector{String})::String
    return join(x, ",")
end
