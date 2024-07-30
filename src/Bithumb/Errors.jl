# Bithumb/Errors
# https://apidocs.bithumb.com/docs/api-%EC%A3%BC%EC%9A%94-%EC%97%90%EB%9F%AC-%EC%BD%94%EB%93%9C

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(e::APIsResult{BithumbAPIError}) = true

# BAD_REQUEST
isretriable(e::APIsResult{BithumbAPIError{5100}}) = false

# NOT_MEMBER
isretriable(e::APIsResult{BithumbAPIError{5200}}) = false

# INVALID_APIKEY
isretriable(e::APIsResult{BithumbAPIError{5300}}) = false

# METHOD_NOT_ALLOWED
isretriable(e::APIsResult{BithumbAPIError{5302}}) = false

# DATABASE_FAIL
isretriable(e::APIsResult{BithumbAPIError{5400}}) = false

# INVALID_SYMBOL
isretriable(e::APIsResult{BithumbAPIError{5500}}) = false

# TOO_MANY_CONNECTIONS
isretriable(e::APIsResult{BithumbAPIError{5600}}) = true
retry_timeout(e::APIsResult{BithumbAPIError{5600}}) = 2
retry_maxcount(e::APIsResult{BithumbAPIError{5600}}) = 50

# UNKNOWN_ERROR
isretriable(e::APIsResult{BithumbAPIError{5900}}) = true
