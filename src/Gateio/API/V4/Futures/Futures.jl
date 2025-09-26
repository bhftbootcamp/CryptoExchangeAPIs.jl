module Futures

include("Candlesticks.jl")
using .Candlesticks

include("Contracts.jl")
using .Contracts

include("FundingRate.jl")
using .FundingRate

include("OrderBook.jl")
using .OrderBook

include("Tickers.jl")
using .Tickers

end
