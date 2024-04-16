module Futures

using CryptoAPIs.Gateio

"""
    public_client = GateioClient(; base_url = "https://api.gateio.ws")
"""
const public_client =
    GateioClient(; base_url = "https://api.gateio.ws")

include("API/Contracts.jl")
using .Contracts

include("API/FundingRate.jl")
using .FundingRate

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

end