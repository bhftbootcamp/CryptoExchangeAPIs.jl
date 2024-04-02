module Spot

using CryptoAPIs.Gateio

"""
    public_client = GateioClient(; base_url = "https://api.gateio.ws")
"""
const public_client =
    GateioClient(; base_url = "https://api.gateio.ws")

include("API/Candle.jl")
using .Candle

include("API/Deposit.jl")
using .Deposit

include("API/Ticker.jl")
using .Ticker

end
