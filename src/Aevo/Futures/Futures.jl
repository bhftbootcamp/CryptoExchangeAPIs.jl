module Futures

using CryptoAPIs.Aevo

"""
    public_client = AevoClient(; base_url = "https://api.aevo.xyz")
"""
const public_client =
    AevoClient(; base_url = "https://api.aevo.xyz")

include("API/FundingRate.jl")
using .FundingRate

include("API/ProductStats.jl")
using .ProductStats

end
