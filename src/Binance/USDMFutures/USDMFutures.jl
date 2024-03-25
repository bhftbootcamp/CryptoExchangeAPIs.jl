module USDMFutures

using CryptoAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://fapi.binance.com")
"""
const public_client =
    BinanceClient(; base_url = "https://fapi.binance.com")

include("API/Candle.jl")
using .Candle

include("API/ExchangeInfo.jl")
using .ExchangeInfo

include("API/FundingRate.jl")
using .FundingRate

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker
end
