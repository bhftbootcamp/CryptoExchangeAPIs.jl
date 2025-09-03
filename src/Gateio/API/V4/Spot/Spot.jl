module Spot

include("Candlesticks.jl")
using .Candlesticks

include("Currencies.jl")
using .Currencies

include("CurrencyPairs.jl")
using .CurrencyPairs

include("Tickers.jl")
using .Tickers

end
