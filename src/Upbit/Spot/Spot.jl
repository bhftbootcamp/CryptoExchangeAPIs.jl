module Spot

using CryptoExchangeAPIs.Upbit

"""
    public_client = UpbitClient(; base_url = "https://api.upbit.com")
"""
const public_client =
    UpbitClient(; base_url = "https://api.upbit.com")

include("API/DayCandle.jl")
using .DayCandle

include("API/MarketList.jl")
using .MarketList

include("API/OrderBook.jl")
using .OrderBook

include("API/StatusWallet.jl")
using .StatusWallet

include("API/Ticker.jl")
using .Ticker

end
