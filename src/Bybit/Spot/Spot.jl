module Spot

using CryptoAPIs.Bybit

"""
    public_client = BybitClient(; base_url = "https://api.bybit.com")
"""
const public_client =
    BybitClient(; base_url = "https://api.bybit.com")

include("API/Candle.jl")
using .Candle

include("API/Deposit.jl")
using .Deposit

include("API/SymbolInfo.jl")
using .SymbolInfo

end
