# Hyperliquid/Utils

function Serde.SerQuery.ser_type(::Type{<:HyperliquidCommonQuery}, x::D)::String where {D<:DateTime}
    return string(round(Int64, datetime2unix(x) * 1000))
end

function Serde.deser(::Type{<:HyperliquidData}, ::Type{<:NanoDate}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

