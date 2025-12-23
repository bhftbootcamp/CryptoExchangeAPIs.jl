module Info

export InfoQuery,
    InfoData,
    info

using Serde
using Dates, NanoDates, TimeZones
using EnumX

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs.Bithumb: WebData
using CryptoExchangeAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct InfoQuery <: BithumbPublicQuery
    timestamp::Maybe{Int} = nanodate2unixmillis(NanoDate(now()))
    retry::Maybe{Int} = 0
end

struct NetworkInfo <: BithumbData
    networkKey::Maybe{String}
    networkName::Maybe{String}
    isDepositAvailable::Maybe{Bool}
    isWithdrawAvailable::Maybe{Bool}
    inOutWithdrawType::Maybe{String}
    smallDepositFeeQuantity::Maybe{Float64}
    smallDepositBaseQuantity::Maybe{Float64}
    withdrawFeeQuantity::Maybe{Float64}
    withdrawMinimumQuantity::Maybe{Float64}
    secondAddressType::Maybe{String}
    secondAddressCd::Maybe{String}
    secondAddressKoName::Maybe{String}
    secondAddressEnName::Maybe{String}
    depositConfirmCount::Maybe{Int64}
    txIdUrl::Maybe{String}
    suspensionMessage::Maybe{String}
    suspensionReason::Maybe{String}
    depositWithdrawNote::Maybe{String}
    isMainNetwork::Maybe{Bool}
end

struct InfoData <: BithumbData
    coinType::Maybe{String}
    coinSymbol::Maybe{String}
    coinName::Maybe{String}
    coinNameEn::Maybe{String}
    coinKrwSise::Maybe{Float64}
    networkInfoList::Maybe{Vector{NetworkInfo}}
end

"""
    info(client::BithumbClient, query::InfoQuery)
    info(client::BithumbClient; kw...)

Get the deposit and withdrawal status of the coin and network information.

[`GET exchange/v1/coin-inout/info`](https://www.bithumb.com/react/info/inout-condition)

## Parameters:

| Parameter        | Type         | Required | Description |
|:-----------------|:-------------|:---------|:------------|
|

## Code samples:

```julia
using CryptoExchangeAPIs.Bithumb

result = Bithumb.Exchange.V1.CoinInout.info()
```
"""
function info(client::BithumbClient, query::InfoQuery)
    return APIsRequest{WebData{Vector{InfoData}}}("GET", "exchange/v1/coin-inout/info", query)(client)
end

function info(client::BithumbClient = BithumbClient(Bithumb.public_web_config); kw...)
    return info(client, InfoQuery(; kw...))
end

end
