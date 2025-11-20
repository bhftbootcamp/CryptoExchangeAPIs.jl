# Hyperliquid/Utils

# Serialize DateTime to milliseconds for query strings
function Serde.SerQuery.ser_type(::Type{<:HyperliquidCommonQuery}, x::D)::String where {D<:DateTime}
    return string(round(Int64, datetime2unix(x) * 1000))
end

# Serialize DateTime to milliseconds for JSON body
function Serde.SerJson.ser_type(::Type{<:HyperliquidData}, x::D)::Int64 where {D<:DateTime}
    return round(Int64, datetime2unix(x) * 1000)
end

# Deserialize milliseconds to NanoDate
function Serde.deser(::Type{<:HyperliquidData}, ::Type{<:NanoDate}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

# Ignore fields with nothing values when serializing to JSON
function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val, x)::Bool
    return x === nothing
end

