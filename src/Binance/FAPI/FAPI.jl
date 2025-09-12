module FAPI

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://fapi.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://fapi.binance.com")

include("V1/V1.jl")
using .V1

end
