module Symbols

export SymbolsQuery,
    SymbolsData,
    symbols

using EnumX
using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enumx State begin
    unknown
    not_online
    pre_online
    online
    suspend
    offline
    transfer_board
    fuse
end

Base.@kwdef struct SymbolsQuery <: HuobiPublicQuery
    ts::Maybe{DateTime} = nothing
end

function Serde.SerQuery.ser_type(::Type{SymbolsQuery}, d::DateTime)
    return round(Int, datetime2unix(d)) * 10^3
end

struct SymbolsData <: HuobiData
    symbol::String
    bcdn::String
    qcdn::String
    bc::String
    qc::String
    state::State.T
    cd::Bool
    te::Bool
    toa::NanoDate
    sp::String
    w::Int
    ttp::Float64
    tap::Float64
    tpp::Float64
    fp::Float64
    tags::Maybe{String}
    d::Maybe{Int}
    elr::Maybe{String}
end

function Serde.deser(::Type{SymbolsData}, ::Type{NanoDate}, x::Int)
    return unixnanos2nanodate(x * 1e6)
end

function Serde.deser(::Type{SymbolsData}, ::Type{State.T}, x::String)
    x == "unknown"        && return State.unknown
    x == "not-online"     && return State.not_online
    x == "pre-online"     && return State.pre_online
    x == "online"         && return State.online
    x == "suspend"        && return State.suspend
    x == "offline"        && return State.offline
    x == "transfer-board" && return State.transfer_board
    x == "fuse"           && return State.fuse
    error("Failed to deserialize state: $x")
end

"""
    symbols(client::HuobiClient, query::SymbolsQuery)
    symbols(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)

Get all Supported Trading Symbol.

[`GET v1/settings/common/symbols`](https://www.htx.com/en-in/opend/newApiPages/?id=7ec51cb5-7773-11ed-9966-0242ac110003)

| Parameter     | Type       | Required | Description |
|:--------------|:-----------|:---------|:------------|
| ts            | Int        | false    |             |

## Code samples:

```julia
using CryptoExchangeAPIs.Huobi

result = Huobi.V1.Settings.Common.symbols()
```
"""
function symbols(client::HuobiClient, query::SymbolsQuery)
    return APIsRequest{Data{Vector{SymbolsData}}}("GET", "v1/settings/common/symbols", query)(client)
end

function symbols(client::HuobiClient = Huobi.HuobiClient(Huobi.public_config); kw...)
    return symbols(client, SymbolsQuery(; kw...))
end

end
