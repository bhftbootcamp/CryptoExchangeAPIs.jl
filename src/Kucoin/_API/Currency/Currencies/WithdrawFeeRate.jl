module WithdrawFeeRate

export WithdrawFeeRateQuery,
    WithdrawFeeRateData,
    withdraw_fee_rate

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Kucoin
using CryptoExchangeAPIs.Kucoin: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef struct WithdrawFeeRateQuery <: KucoinPublicQuery
    #__ empty
end

struct WithdrawFeeRateData <: KucoinData
    code::String
    currency::String
    name::String
    withdrawMinFee::Float64
    withdrawFeeRate::Maybe{Float64}
    withdrawMinSize::Float64
    innerWithdrawMinFee::Float64
    iconUrl::Maybe{String}
    chainName::Maybe{String}
    chain::String
end

"""
    withdraw_fee_rate(client::KucoinClient, query::WithdrawFeeRateQuery)
    withdraw_fee_rate(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_web_config); kw...)

## Code samples:

```julia
using CryptoExchangeAPIs.Kucoin

result = Kucoin._API.Currency.Currencies.withdraw_fee_rate()
```
"""
function withdraw_fee_rate(client::KucoinClient, query::WithdrawFeeRateQuery)
    return APIsRequest{Data{Vector{WithdrawFeeRateData}}}("GET", "_api/currency/currencies/withdraw-fee-rate", query)(client)
end

function withdraw_fee_rate(client::KucoinClient = Kucoin.KucoinClient(Kucoin.public_web_config); kw...)
    return withdraw_fee_rate(client, WithdrawFeeRateQuery(; kw...))
end

end

