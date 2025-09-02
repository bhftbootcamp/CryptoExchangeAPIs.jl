module USDMFutures

using CryptoExchangeAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://fapi.binance.com")
"""
const public_client = BinanceClient(; base_url = "https://fapi.binance.com")

include("FAPI/FAPI.jl")
using .FAPI

include("Futures/Futures.jl")
using .Futures

end
