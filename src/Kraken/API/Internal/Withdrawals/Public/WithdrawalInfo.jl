module WithdrawalInfo

export WithdrawalInfoQuery,
    WithdrawalInfoData,
    withdrawal_info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Kraken
using CryptoExchangeAPIs.Kraken: InternalData
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct WithdrawalInfoQuery <: KrakenInternalPublicQuery
    preferred_asset_name::Maybe{String} = "new"
end

struct NetworkInfo <: KrakenData
    network::Maybe{String}
    chain_id::Maybe{String}
    contract_address::Maybe{String}
end

struct WithdrawalInfoData <: KrakenData
    type_name::Maybe{String}
    asset::String
    asset_name::String
    withdrawal_network_info::NetworkInfo
    name_display::Maybe{String}
    fee::Maybe{Float64}
    min_amount::Maybe{Float64}
    max_amount::Maybe{Float64}
end

Serde.nulltype(::Type{NetworkInfo}) = NetworkInfo(nothing, nothing, nothing)

"""
    withdrawal_info(client::KrakenClient, query::WithdrawalInfoQuery)
    withdrawal_info(client::KrakenClient = Kraken.KrakenClient(Kraken.public_internal_config); kw...)

[`GET api/internal/withdrawals/public/methods`](https://support.kraken.com/hc/en-us/articles/360000767986-Cryptocurrency-withdrawal-fees-and-minimums)

## Code samples:

```julia
using CryptoExchangeAPIs.Kraken

result = Kraken.API.Internal.Withdrawals.Public.withdrawal_info()
```
"""
function withdrawal_info(client::KrakenClient, query::WithdrawalInfoQuery)
    return APIsRequest{InternalData{Vector{WithdrawalInfoData}}}("GET", "api/internal/withdrawals/public/methods", query)(client)
end

function withdrawal_info(
    client::KrakenClient = Kraken.KrakenClient(Kraken.public_internal_config);
    kw...,
)
    return withdrawal_info(client, WithdrawalInfoQuery(; kw...))
end

end
