# Cryptocom/Utils

function Serde.SerQuery.ser_type(::Type{<:CryptocomCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return (round(Int64, datetime2unix(x)) * 1000)
end

function Serde.deser(::Type{<:CryptocomData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end
