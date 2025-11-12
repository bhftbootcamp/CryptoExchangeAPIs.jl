# Hyperliquid Examples
# https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Hyperliquid


# =============================================================================
# General endpoints
# =============================================================================

# Get mids for all coins
Hyperliquid.Info.all_mids()

# Get L2 order book
Hyperliquid.Info.l2_book(;
    coin = "BTC"
)

Hyperliquid.Info.l2_book(;
    coin = "ETH",
    nSigFigs = 5
)

# Get candle snapshot
Hyperliquid.Info.candle_snapshot(;
    coin = "BTC",
    interval = "1h",
    startTime = 1681923600000
)

Hyperliquid.Info.candle_snapshot(;
    coin = "ETH",
    interval = "15m",
    startTime = 1681923600000,
    endTime = 1681924499999
)


# =============================================================================
# Perpetuals metadata
# =============================================================================

# Get perpetuals metadata
Hyperliquid.Info.meta()

# Get perpetuals metadata with asset contexts
Hyperliquid.Info.meta_and_asset_ctxs()

# Get all perpetual dexs
Hyperliquid.Info.perp_dexs()

# Get perps at open interest cap
Hyperliquid.Info.perps_at_open_interest_cap()

# Get perp deploy auction status
Hyperliquid.Info.perp_deploy_auction_status()

# Get perp dex status
Hyperliquid.Info.perp_dex_status(;
    dex = ""
)


# =============================================================================
# Spot metadata
# =============================================================================

# Get spot metadata
Hyperliquid.Info.spot_meta()

# Get spot metadata with asset contexts
Hyperliquid.Info.spot_meta_and_asset_ctxs()

# Get token details
Hyperliquid.Info.token_details(;
    tokenId = "0x6d1e7cde53ba9467b783cb7c530ce054"
)

# Get aligned quote token info
Hyperliquid.Info.aligned_quote_token_info(;
    token = 0
)


# =============================================================================
# User account queries
# =============================================================================

example_user = "0x0000000000000000000000000000000000000000"

# Get user's open orders
Hyperliquid.Info.open_orders(;
    user = example_user
)

# Get user's open orders with frontend info
Hyperliquid.Info.frontend_open_orders(;
    user = example_user
)

# Get user's fills
Hyperliquid.Info.user_fills(;
    user = example_user
)

# Get user's fills by time
Hyperliquid.Info.user_fills_by_time(;
    user = example_user,
    startTime = 1681222254710
)

Hyperliquid.Info.user_fills_by_time(;
    user = example_user,
    startTime = 1681222254710,
    endTime = 1681922254710,
    aggregateByTime = true
)

# Get user's historical orders
Hyperliquid.Info.historical_orders(;
    user = example_user
)

# Get user's TWAP slice fills
Hyperliquid.Info.user_twap_slice_fills(;
    user = example_user
)

# Get user's perpetuals account state
Hyperliquid.Info.clearinghouse_state(;
    user = example_user
)

# Get user's spot token balances
Hyperliquid.Info.spot_clearinghouse_state(;
    user = example_user
)

# Get user's active asset data
Hyperliquid.Info.active_asset_data(;
    user = example_user,
    coin = "BTC"
)

# Get user's subaccounts
Hyperliquid.Info.sub_accounts(;
    user = example_user
)

# Get user's portfolio
Hyperliquid.Info.portfolio(;
    user = example_user
)

# Get user's role
Hyperliquid.Info.user_role(;
    user = example_user
)


# =============================================================================
# User operations
# =============================================================================

# Get user rate limits
Hyperliquid.Info.user_rate_limit(;
    user = example_user
)

# Query order status
Hyperliquid.Info.order_status(;
    user = example_user,
    oid = 91490942
)

# Get user funding history
Hyperliquid.Info.user_funding(;
    user = example_user,
    startTime = 1681222254710
)

# Get user non-funding ledger updates
Hyperliquid.Info.user_non_funding_ledger_updates(;
    user = example_user,
    startTime = 1681222254710
)

# Get funding history for a coin
Hyperliquid.Info.funding_history(;
    coin = "ETH",
    startTime = 1683849600076
)

Hyperliquid.Info.funding_history(;
    coin = "BTC",
    startTime = 1683849600076,
    endTime = 1683950000076
)

# Get predicted fundings
Hyperliquid.Info.predicted_fundings()

# Get user's referral information
Hyperliquid.Info.referral(;
    user = example_user
)

# Get user's fees
Hyperliquid.Info.user_fees(;
    user = example_user
)

# Get user's staking delegations
Hyperliquid.Info.delegations(;
    user = example_user
)

# Get user's staking summary
Hyperliquid.Info.delegator_summary(;
    user = example_user
)

# Get user's staking history
Hyperliquid.Info.delegator_history(;
    user = example_user
)

# Get user's staking rewards
Hyperliquid.Info.delegator_rewards(;
    user = example_user
)

# Get user's HIP-3 DEX abstraction state
Hyperliquid.Info.user_dex_abstraction(;
    user = example_user
)


# =============================================================================
# Vaults and builder
# =============================================================================

example_vault = "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303"

# Get vault details
Hyperliquid.Info.vault_details(;
    vaultAddress = example_vault
)

Hyperliquid.Info.vault_details(;
    vaultAddress = example_vault,
    user = example_user
)

# Get user's vault deposits
Hyperliquid.Info.user_vault_equities(;
    user = example_user
)

# Check builder fee approval
Hyperliquid.Info.max_builder_fee(;
    user = example_user,
    builder = "0x0000000000000000000000000000000000000001"
)

