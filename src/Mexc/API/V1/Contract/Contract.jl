module Contract

include("Detail.jl")
using .Detail

include("Ticker.jl")
using .Ticker

include("FundingRate.jl")
using .FundingRate

include("FundingRateHistory.jl")
using .FundingRateHistory

end
