# Mexc/Errors
# https://www.mexc.com/api-docs/spot-v3/general-info#error-code

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# --- Spot --------------------------------------------------------------------

# UNDF
isretriable(::APIsResult{MexcSpotAPIError}) = true

# Too many requests
isretriable(e::APIsResult{MexcSpotAPIError{429}}) = true
retry_timeout(e::APIsResult{MexcSpotAPIError{429}}) = 10
retry_maxcount(e::APIsResult{MexcSpotAPIError{429}}) = 50

# Internal error
isretriable(e::APIsResult{MexcSpotAPIError{500}}) = true
retry_timeout(e::APIsResult{MexcSpotAPIError{500}}) = 20
retry_maxcount(e::APIsResult{MexcSpotAPIError{500}}) = 10

# Service not available
isretriable(e::APIsResult{MexcSpotAPIError{503}}) = true
retry_timeout(e::APIsResult{MexcSpotAPIError{503}}) = 20
retry_maxcount(e::APIsResult{MexcSpotAPIError{503}}) = 2

# Gateway Time-out
isretriable(e::APIsResult{MexcSpotAPIError{504}}) = true
retry_timeout(e::APIsResult{MexcSpotAPIError{504}}) = 20
retry_maxcount(e::APIsResult{MexcSpotAPIError{504}}) = 2

# --- Futures -----------------------------------------------------------------

# UNDF
isretriable(::APIsResult{MexcFuturesAPIError}) = true

# Internal error
isretriable(e::APIsResult{MexcFuturesAPIError{500}}) = true
retry_timeout(e::APIsResult{MexcFuturesAPIError{500}}) = 20
retry_maxcount(e::APIsResult{MexcFuturesAPIError{500}}) = 10

# System busy
isretriable(e::APIsResult{MexcFuturesAPIError{501}}) = true
retry_timeout(e::APIsResult{MexcFuturesAPIError{501}}) = 20
retry_maxcount(e::APIsResult{MexcFuturesAPIError{501}}) = 10

# Requests are too frequent
isretriable(e::APIsResult{MexcFuturesAPIError{510}}) = true
retry_timeout(e::APIsResult{MexcFuturesAPIError{510}}) = 10
retry_maxcount(e::APIsResult{MexcFuturesAPIError{510}}) = 50

# Invalid request
isretriable(e::APIsResult{MexcFuturesAPIError{513}}) = true
retry_timeout(e::APIsResult{MexcFuturesAPIError{513}}) = 20
retry_maxcount(e::APIsResult{MexcFuturesAPIError{513}}) = 10
