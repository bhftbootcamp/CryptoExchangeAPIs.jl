module Spot

using CryptoAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://api.binance.com")
"""
const public_client =
    BinanceClient(; base_url = "https://api.binance.com")

include("API/AccountTrade.jl")
using .AccountTrade

include("API/AvgPrice.jl")
using .AvgPrice

include("API/Candle.jl")
using .Candle

include("API/CoinInformation.jl")
using .CoinInformation

include("API/DepositLog.jl")
using .DepositLog

include("API/ExchangeInfo.jl")
using .ExchangeInfo

include("API/OrderBook.jl")
using .OrderBook

include("API/ServerTime.jl")
using .ServerTime

include("API/Ticker.jl")
using .Ticker

include("API/WithdrawalLog.jl")
using .WithdrawalLog

end
