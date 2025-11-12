# Hyperliquid/Utils

function Serde.SerQuery.ser_type(::Type{<:HyperliquidCommonQuery}, x::D)::String where {D<:DateTime}
    return string(round(Int64, datetime2unix(x) * 1000))
end

function Serde.deser(::Type{<:HyperliquidData}, ::Type{<:NanoDate}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

# Ignore fields with nothing values when serializing to JSON
function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:dex}, x)::Bool
    return x === nothing
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:user}, x)::Bool
    return x === nothing
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:nSigFigs}, x)::Bool
    return x === nothing
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:mantissa}, x)::Bool
    return x === nothing
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:endTime}, x)::Bool
    return x === nothing
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val{:aggregateByTime}, x)::Bool
    return x === nothing
end

