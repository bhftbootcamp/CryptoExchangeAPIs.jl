module Spot

using CryptoExchangeAPIs.Kucoin

"""
    public_client = KucoinClient(; base_url = "https://api.kucoin.com")
"""
const public_client =
    KucoinClient(; base_url = "https://api.kucoin.com")

include("API/Candle.jl")
using .Candle

include("API/Deposit.jl")
using .Deposit

include("API/Ticker.jl")
using .Ticker

end
