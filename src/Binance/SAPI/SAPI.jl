module SAPI

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://api.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://api.binance.com")

include("V1/V1.jl")

end
