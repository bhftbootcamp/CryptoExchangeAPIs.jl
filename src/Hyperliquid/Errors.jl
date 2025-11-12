# Hyperliquid/Errors

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# Default: API errors are retriable
isretriable(::APIsResult{HyperliquidAPIError}) = true
retry_timeout(::APIsResult{HyperliquidAPIError}) = 2.0
retry_maxcount(::APIsResult{HyperliquidAPIError}) = 3

