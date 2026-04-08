module V3

include("Capital/Capital.jl")
using .Capital

include("ExchangeInfo.jl")
using .ExchangeInfo

include("Ticker24hr.jl")
using .Ticker24hr

include("AvgPrice.jl")
using .AvgPrice

include("Depth.jl")
using .Depth

include("Klines.jl")
using .Klines

include("Time.jl")
using .Time

end
