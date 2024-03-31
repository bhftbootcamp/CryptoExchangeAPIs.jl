module USDMFutures

using CryptoAPIs.Binance

"""
    public_client = BinanceClient(; base_url = "https://fapi.binance.com")
"""
const public_client =
    BinanceClient(; base_url = "https://fapi.binance.com")

include("API/Candle.jl")
using .Candle

include("API/ContinuousCandle.jl")
using .ContinuousCandle

include("API/ExchangeInfo.jl")
using .ExchangeInfo

include("API/FundingRate.jl")
using .FundingRate

include("API/LongShortRatio.jl")
using .LongShortRatio

include("API/OpenInterestHist.jl")
using .OpenInterestHist

include("API/OrderBook.jl")
using .OrderBook

include("API/PremiumIndex.jl")
using .PremiumIndex

include("API/Ticker.jl")
using .Ticker

end
