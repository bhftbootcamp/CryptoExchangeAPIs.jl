module Futures

using CryptoExchangeAPIs.Mexc

"""
    public_client = MexcClient(; base_url = "https://contract.mexc.com")
"""
const public_client =
    MexcClient(; base_url = "https://contract.mexc.com")

include("API/ContractDetail.jl")
using .ContractDetail

include("API/FundingRate.jl")
using .FundingRate

include("API/FundingRateHistory.jl")
using .FundingRateHistory

end
