module Common

using CryptoExchangeAPIs.Bybit

"""
    public_client = BybitClient(; base_url = "https://api.bybit.com")
"""
const public_client =
    BybitClient(; base_url = "https://api.bybit.com")

include("API/Instrument.jl")
using .Instrument


end