# Upbit/Errors
# https://ujhin.github.io/upbit-client-docs/#errors

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{UpbitAPIError}) = true

# INVALID_SYMBOL
isretriable(e::APIsResult{UpbitAPIError{404}}) = false
