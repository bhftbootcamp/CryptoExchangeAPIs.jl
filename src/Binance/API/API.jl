module API

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://api.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://api.binance.com")

include("V3/V3.jl")

end
