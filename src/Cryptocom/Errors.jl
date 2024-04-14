# Cryptocom/Errors
# https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#response-and-reason-codes

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{CryptocomAPIError}) = true

# Success
isretriable(e::APIsResult{CryptocomAPIError{0}}) = false

# Server Timeout
isretriable(e::APIsResult{CryptocomAPIError{40801}}) = true
retry_timeout(e::APIsResult{CryptocomAPIError{40801}}) = 10
retry_maxcount(e::APIsResult{CryptocomAPIError{40801}}) = 50

# Requests have exceeded rate limits
isretriable(e::APIsResult{CryptocomAPIError{42901}}) = true
retry_timeout(e::APIsResult{CryptocomAPIError{42901}}) = 10
retry_maxcount(e::APIsResult{CryptocomAPIError{42901}}) = 50

#Instrument has expired
isretriable(e::APIsResult{CryptocomAPIError{206}}) = false

#Instrument is not tradable
isretriable(e::APIsResult{CryptocomAPIError{208}}) = false

#Market is not open
isretriable(e::APIsResult{CryptocomAPIError{309}}) = false

#Bad request
isretriable(e::APIsResult{CryptocomAPIError{40001}}) = false

#Required argument is blank or missing
isretriable(e::APIsResult{CryptocomAPIError{40004}}) = false

#Invalid date
isretriable(e::APIsResult{CryptocomAPIError{40005}}) = false

#IP address not whitelisted
isretriable(e::APIsResult{CryptocomAPIError{40103}}) = false

#Not found
isretriable(e::APIsResult{CryptocomAPIError{40401}}) = false