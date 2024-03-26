module CoinMFutures

using CryptoAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://dapi.binance.com")
"""
const public_client =
    BinanceClient(; base_url = "https://dapi.binance.com")

include("API/Candle.jl")
using .Candle

include("API/ContinuousCandle.jl")
using .ContinuousCandle

include("API/ExchangeInfo.jl")
using .ExchangeInfo

include("API/FundingRate.jl")
using .FundingRate

include("API/IncomeLog.jl")
using .IncomeLog

include("API/OrderBook.jl")
using .OrderBook

include("API/PremiumIndex.jl")
using .PremiumIndex

include("API/Ticker.jl")
using .Ticker

include("API/Ticker24hr.jl")
using .Ticker24hr

end
