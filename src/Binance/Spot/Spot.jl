module Spot

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://api.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://api.binance.com")

include("API/API.jl")
using .API

include("SAPI/SAPI.jl")
using .SAPI

end
