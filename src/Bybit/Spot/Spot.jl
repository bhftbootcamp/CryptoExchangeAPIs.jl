module Spot

using CryptoAPIs.Bybit

"""
    public_client = BybitClient(; base_url = "https://api.bybit.com")
"""
const public_client =
    BybitClient(; base_url = "https://api.bybit.com")

include("API/Candle.jl")
using .Candle

include("API/SymbolsInfo.jl")
using .SymbolsInfo

include("API/Deposit.jl")
using .Deposit

end
