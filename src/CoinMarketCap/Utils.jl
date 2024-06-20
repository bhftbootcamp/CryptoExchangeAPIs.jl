# CoinMarketCap/Utils

function Serde.deser(::Type{<:CoinMarketCapData}, ::Type{<:Maybe{NanoDate}}, x::Int64)::NanoDate
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{<:CoinMarketCapData}, ::Type{<:Maybe{NanoDate}}, x::AbstractString)::NanoDate
    return unixnanos2nanodate(parse(Int64, x) * 1e6)
end

function Serde.SerQuery.ser_type(::Type{<:CoinMarketCapCommonQuery}, x::D)::Int64 where {D<:DateTime}
    return (round(Int64, datetime2unix(x)) * 1000)
end