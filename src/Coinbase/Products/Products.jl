module Products

include("AllTradingPairs.jl")
using .AllTradingPairs

include("Candles.jl")
using .Candles

include("Ticker.jl")
using .Ticker

end
