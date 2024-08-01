module Spot

using CryptoExchangeAPIs.Poloniex

"""
    public_client = PoloniexClient(; base_url = "https://api.poloniex.com")
"""
const public_client =
    PoloniexClient(; base_url = "https://api.poloniex.com")

include("API/Candle.jl")
using .Candle

include("API/Currency.jl")
using .Currency

include("API/OrderBook.jl")
using .OrderBook

include("API/Market.jl")
using .Market

include("API/Ticker.jl")
using .Ticker

end
