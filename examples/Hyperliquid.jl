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
    startTime = 1762851600000
)

Hyperliquid.Info.candle_snapshot(;
    coin = "ETH",
    interval = "15m",
    startTime = 1762851600000,
    endTime = 1762938000000
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
