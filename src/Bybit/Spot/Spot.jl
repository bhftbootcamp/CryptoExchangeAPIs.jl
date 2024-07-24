module Spot

using CryptoAPIs.Bybit

"""
    public_client = BybitClient(; base_url = "https://api.bybit.com")
"""
const public_client =
    BybitClient(; base_url = "https://api.bybit.com")

include("API/Candle.jl")
using .Candle

include("API/CoinInfo.jl")
using .CoinInfo

include("API/Deposit.jl")
using .Deposit

include("API/OrderBook.jl")
using .OrderBook

include("API/SymbolInfo.jl")
using .SymbolInfo

include("API/Ticker.jl")
using .Ticker

include("API/TradeHistory.jl")
using .TradeHistory

end
