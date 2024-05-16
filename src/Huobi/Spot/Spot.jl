module Spot

using CryptoAPIs.Huobi

"""
    public_client = HuobiClient(; base_url = "https://api.huobi.pro")
"""
const public_client =
    HuobiClient(; base_url = "https://api.huobi.pro")

include("API/Candle.jl")
using .Candle

include("API/CommonSymbol.jl")
using .CommonSymbol

include("API/Currency.jl")
using .Currency

include("API/DepositWithdrawal.jl")
using .DepositWithdrawal

include("API/OrderBook.jl")
using .OrderBook

include("API/OrderLog.jl")
using .OrderLog

include("API/Ticker.jl")
using .Ticker

end
