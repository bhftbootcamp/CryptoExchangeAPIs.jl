function Serde.SerQuery.ser_type(::Type{<:MexcCommonQuery}, dt::DateTime)
    return round(Int, 1000 * datetime2unix(dt))
end

function Serde.SerJson.ser_type(::Type{<:MexcCommonQuery}, dt::DateTime)
    return round(Int, 1000 * datetime2unix(dt))
end

function Serde.deser(::Type{<:MexcData}, ::Type{NanoDate},x::Int)
    return unixnanos2nanodate(x * 10^6)
end

function Serde.deser(::Type{<:MexcData}, ::Type{NanoDate}, x::String)
    return unixnanos2nanodate(parse(Int, x) * 10^6)
end
