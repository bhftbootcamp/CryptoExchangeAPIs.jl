module Info

# General endpoints
include("AllMids.jl")
using .AllMids

include("L2Book.jl")
using .L2Book

include("CandleSnapshot.jl")
using .CandleSnapshot

# Perpetuals metadata
include("Meta.jl")
using .Meta

include("MetaAndAssetCtxs.jl")
using .MetaAndAssetCtxs

include("PerpDexs.jl")
using .PerpDexs

include("PerpsAtOpenInterestCap.jl")
using .PerpsAtOpenInterestCap

include("PerpDeployAuctionStatus.jl")
using .PerpDeployAuctionStatus

include("PerpDexLimits.jl")
using .PerpDexLimits

include("PerpDexStatus.jl")
using .PerpDexStatus

# Spot metadata
include("SpotMeta.jl")
using .SpotMeta

include("SpotMetaAndAssetCtxs.jl")
using .SpotMetaAndAssetCtxs

include("SpotDeployState.jl")
using .SpotDeployState

include("SpotPairDeployAuctionStatus.jl")
using .SpotPairDeployAuctionStatus

include("TokenDetails.jl")
using .TokenDetails

include("AlignedQuoteTokenInfo.jl")
using .AlignedQuoteTokenInfo

end