module Spot

using CryptoAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://api.binance.com")
"""
const public_client =
    BinanceClient(; base_url = "https://api.binance.com")

include("API/AvgPrice.jl")
using .AvgPrice

include("API/Candle.jl")
using .Candle

include("API/CoinInformation.jl")
using .CoinInformation

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

end
