# Errors
# https://docs.kucoin.com/#request

import ..CryptoAPIs: APIsResult, APIsUndefError
import ..CryptoAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(e::APIsResult{KucoinAPIError}) = true

# Order creation for this pair suspended
isretriable(e::APIsResult{KucoinAPIError{200001}}) = false

# Order cancel for this pair suspended
isretriable(e::APIsResult{KucoinAPIError{200002}}) = false

# Number of orders breached the limit
isretriable(e::APIsResult{KucoinAPIError{200003}}) = false

# Please complete the KYC verification before you trade XX
isretriable(e::APIsResult{KucoinAPIError{200009}}) = false

# Balance insufficient
isretriable(e::APIsResult{KucoinAPIError{200004}}) = false

# withdraw.disabled -- Currency/Chain withdraw is closed, or user is frozen to withdraw
isretriable(e::APIsResult{KucoinAPIError{260210}}) = false

# Any of KC-API-KEY, KC-API-SIGN, KC-API-TIMESTAMP, KC-API-PASSPHRASE is missing in your request header
isretriable(e::APIsResult{KucoinAPIError{400001}}) = false

# KC-API-TIMESTAMP Invalid
isretriable(e::APIsResult{KucoinAPIError{400002}}) = false

# KC-API-KEY not exists
isretriable(e::APIsResult{KucoinAPIError{400003}}) = false

# KC-API-PASSPHRASE error
isretriable(e::APIsResult{KucoinAPIError{400004}}) = false

# Signature error
isretriable(e::APIsResult{KucoinAPIError{400005}}) = false

# The requested ip address is not in the api whitelist
isretriable(e::APIsResult{KucoinAPIError{400006}}) = false

# Access Denied
isretriable(e::APIsResult{KucoinAPIError{400007}}) = false

# Url Not Found
isretriable(e::APIsResult{KucoinAPIError{404000}}) = false

# Parameter Error
isretriable(e::APIsResult{KucoinAPIError{400100}}) = false

# Forbidden to place an order
isretriable(e::APIsResult{KucoinAPIError{400200}}) = false

# Your located country/region is currently not supported for the trading of this token
isretriable(e::APIsResult{KucoinAPIError{400500}}) = false

# validation.createOrder.symbolNotAvailable -- The trading pair has not yet started trading
isretriable(e::APIsResult{KucoinAPIError{400600}}) = false

# Transaction restricted, there's a risk problem in your account
isretriable(e::APIsResult{KucoinAPIError{400700}}) = false

# Leverage order failed
isretriable(e::APIsResult{KucoinAPIError{400800}}) = false

# User are frozen
isretriable(e::APIsResult{KucoinAPIError{411100}}) = false

# Unsupported Media Type -- The Content-Type of the request header needs to be set to application/json
isretriable(e::APIsResult{KucoinAPIError{415000}}) = false

# Too many request
isretriable(e::APIsResult{KucoinAPIError{429000}}) = true
retry_timeout(e::APIsResult{KucoinAPIError{429000}}) = 5
retry_maxcount(e::APIsResult{KucoinAPIError{429000}}) = 50

# Internal Server Error
isretriable(e::APIsResult{KucoinAPIError{500000}}) = true

# symbol not exists
isretriable(e::APIsResult{KucoinAPIError{900001}}) = false
