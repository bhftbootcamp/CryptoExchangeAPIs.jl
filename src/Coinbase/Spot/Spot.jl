module Spot

using CryptoAPIs.Coinbase

"""
    public_client = CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")
"""
const public_client =
    CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")

include("API/Candle.jl")
using .Candle

include("API/Currency.jl")
using .Currency

include("API/Ticker.jl")
using .Ticker

end
