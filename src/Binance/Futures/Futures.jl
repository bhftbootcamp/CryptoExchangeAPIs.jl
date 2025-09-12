module Futures

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://fapi.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://fapi.binance.com")

include("Data/Data.jl")
using .Data

end
