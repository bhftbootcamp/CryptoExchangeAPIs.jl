module Spot

using CryptoAPIs.Poloniex

"""
    public_client = PoloniexClient(; base_url = "https://api.poloniex.com")
"""
const public_client =
    PoloniexClient(; base_url = "https://api.poloniex.com")

include("API/Candle.jl")
using .Candle

include("API/CurrencyV2.jl")
using .CurrencyV2

include("API/OrderBook.jl")
using .OrderBook

include("API/Market.jl")
using .Market

include("API/Ticker.jl")
using .Ticker

end
