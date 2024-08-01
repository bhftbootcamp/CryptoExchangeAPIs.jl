module Spot

using CryptoExchangeAPIs.Gateio

"""
    public_client = GateioClient(; base_url = "https://api.gateio.ws")
"""
const public_client =
    GateioClient(; base_url = "https://api.gateio.ws")

include("API/Candle.jl")
using .Candle

include("API/Currency.jl")
using .Currency

include("API/Deposit.jl")
using .Deposit

include("API/Ticker.jl")
using .Ticker

end
