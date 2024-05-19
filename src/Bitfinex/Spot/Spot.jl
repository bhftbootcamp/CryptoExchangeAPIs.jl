module Spot

using CryptoAPIs.Bitfinex

"""
    public_client = BitfinexClient(; base_url = "https://api-pub.bitfinex.com")
"""
const public_client =
    BitfinexClient(; base_url = "https://api-pub.bitfinex.com")

include("API/Candle.jl")
using .Candle

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

include("API/TradesPair.jl")
using .TradesPair

end
