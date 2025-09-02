module Futures

include("DataGlobalLongShortAccountRatio.jl")
using .DataGlobalLongShortAccountRatio

include("DataOpenInterestHist.jl")
using .DataOpenInterestHist

include("DataTakerLongShortRatio.jl")
using .DataTakerLongShortRatio

end
