module Market

include("Instruments.jl")
using .Instruments

include("Candles.jl")
using .Candles

include("HistoryCandles.jl")
using .HistoryCandles

end
