module Market

include("InstrumentsInfo.jl")
using .InstrumentsInfo

include("Kline.jl")
using .Kline

include("Orderbook.jl")
using .Orderbook

include("Tickers.jl")
using .Tickers

include("Insurance.jl")
using .Insurance

include("Funding/Funding.jl")
using .Funding

end
