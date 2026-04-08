# Mexc/Errors
# https://mexcdevelop.github.io/apidocs/spot_v3_en/#error-code

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{MexcAPIError}) = true

# UNKNOWN_ORDER_SENT
isretriable(e::APIsResult{MexcAPIError{-2011}}) = false

# OPERATION_NOT_ALLOWED
isretriable(e::APIsResult{MexcAPIError{26}}) = false

# API_KEY_REQUIRED
isretriable(e::APIsResult{MexcAPIError{400}}) = false

# NO_AUTHORITY
isretriable(e::APIsResult{MexcAPIError{401}}) = false

# ACCESS_DENIED
isretriable(e::APIsResult{MexcAPIError{403}}) = false

# TOO_MANY_REQUESTS
isretriable(e::APIsResult{MexcAPIError{429}}) = true
retry_timeout(e::APIsResult{MexcAPIError{429}}) = e.response.headers.retry_after
retry_maxcount(e::APIsResult{MexcAPIError{429}}) = 25

# INTERNAL_ERROR
isretriable(e::APIsResult{MexcAPIError{500}}) = true

# SERVICE_NOT_AVAILABLE
isretriable(e::APIsResult{MexcAPIError{503}}) = true

# GATEWAY_TIMEOUT
isretriable(e::APIsResult{MexcAPIError{504}}) = true

# SIGNATURE_VERIFICATION_FAILED
isretriable(e::APIsResult{MexcAPIError{602}}) = false

# BAD_SYMBOL
isretriable(e::APIsResult{MexcAPIError{10007}}) = false

# INVALID_ACCESS_KEY
isretriable(e::APIsResult{MexcAPIError{10072}}) = false

# INVALID_REQUEST_TIME
isretriable(e::APIsResult{MexcAPIError{10073}}) = true

# INSUFFICIENT_BALANCE
isretriable(e::APIsResult{MexcAPIError{10101}}) = false

# SUSPENDED_TRANSACTION
isretriable(e::APIsResult{MexcAPIError{30000}}) = false

# INVALID_SYMBOL
isretriable(e::APIsResult{MexcAPIError{30014}}) = false

# TRADING_DISABLED
isretriable(e::APIsResult{MexcAPIError{30016}}) = false

# API_KEY_FORMAT_INVALID
isretriable(e::APIsResult{MexcAPIError{700001}}) = false

# SIGNATURE_NOT_VALID
isretriable(e::APIsResult{MexcAPIError{700002}}) = false

# TIMESTAMP_OUTSIDE_RECV_WINDOW
isretriable(e::APIsResult{MexcAPIError{700003}}) = true

# RECV_WINDOW_TOO_LARGE
isretriable(e::APIsResult{MexcAPIError{700005}}) = false

# IP_NOT_WHITELISTED
isretriable(e::APIsResult{MexcAPIError{700006}}) = false

# NO_PERMISSION
isretriable(e::APIsResult{MexcAPIError{700007}}) = false
