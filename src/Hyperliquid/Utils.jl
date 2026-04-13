# Hyperliquid/Utils

function Serde.SerQuery.ser_type(::Type{<:HyperliquidCommonQuery}, x::DateTime)
    return round(Int, datetime2unix(x) * 1000)
end

function Serde.SerJson.ser_type(::Type{<:HyperliquidCommonQuery}, x::DateTime)
    return round(Int, datetime2unix(x) * 1000)
end

function Serde.SerJson.ser_ignore_field(::Type{<:HyperliquidCommonQuery}, ::Val, x)
    return isnothing(x)
end

function Serde.deser(::Type{<:HyperliquidData}, ::Type{NanoDate}, x::Int)
    return unixnanos2nanodate(x * 1e6)
end
