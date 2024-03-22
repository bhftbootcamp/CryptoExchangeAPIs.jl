# Coinbase/Errors

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{CoinbaseAPIError}) = true

# Invalid Price
isretriable(e::APIsResult{CoinbaseAPIError{Symbol("Invalid Price")}}) = false

# NotFound
isretriable(e::APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = false

# Public rate limit exceeded
isretriable(e::APIsResult{CoinbaseAPIError{Symbol("Public rate limit exceeded")}}) = true
retry_timeout(e::APIsResult{CoinbaseAPIError{Symbol("Public rate limit exceeded")}}) = 5
retry_maxcount(e::APIsResult{CoinbaseAPIError{Symbol("Public rate limit exceeded")}}) = 50

# Public rate limit exceeded
isretriable(e::APIsResult{CoinbaseAPIError{Symbol("Order book not found for product id PYUSD-USD")}}) = true
retry_maxcount(e::APIsResult{CoinbaseAPIError{Symbol("Order book not found for product id PYUSD-USD")}}) = 1
retry_timeout(e::APIsResult{CoinbaseAPIError{Symbol("Order book not found for product id PYUSD-USD")}}) = 2
