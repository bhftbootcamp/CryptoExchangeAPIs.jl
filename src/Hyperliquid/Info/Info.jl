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

# User account
include("OpenOrders.jl")
using .OpenOrders

include("FrontendOpenOrders.jl")
using .FrontendOpenOrders

include("UserFills.jl")
using .UserFills

include("UserFillsByTime.jl")
using .UserFillsByTime

include("HistoricalOrders.jl")
using .HistoricalOrders

include("UserTwapSliceFills.jl")
using .UserTwapSliceFills

include("ClearinghouseState.jl")
using .ClearinghouseState

include("SpotClearinghouseState.jl")
using .SpotClearinghouseState

include("ActiveAssetData.jl")
using .ActiveAssetData

include("SubAccounts.jl")
using .SubAccounts

include("Portfolio.jl")
using .Portfolio

include("UserRole.jl")
using .UserRole

# User operations
include("UserRateLimit.jl")
using .UserRateLimit

include("OrderStatus.jl")
using .OrderStatus

include("UserFunding.jl")
using .UserFunding

include("UserNonFundingLedgerUpdates.jl")
using .UserNonFundingLedgerUpdates

include("FundingHistory.jl")
using .FundingHistory

include("PredictedFundings.jl")
using .PredictedFundings

include("Referral.jl")
using .Referral

include("UserFees.jl")
using .UserFees

include("Delegations.jl")
using .Delegations

include("DelegatorSummary.jl")
using .DelegatorSummary

include("DelegatorHistory.jl")
using .DelegatorHistory

include("DelegatorRewards.jl")
using .DelegatorRewards

include("UserDexAbstraction.jl")
using .UserDexAbstraction

# Vaults and builder
include("VaultDetails.jl")
using .VaultDetails

include("UserVaultEquities.jl")
using .UserVaultEquities

include("MaxBuilderFee.jl")
using .MaxBuilderFee

end

