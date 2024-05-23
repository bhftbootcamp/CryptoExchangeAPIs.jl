# Errors
# https://docs.bitfinex.com/docs/abbreviations-glossary#errorinfo-codes

import ..CryptoAPIs: APIsResult, APIsUndefError
import ..CryptoAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{BitfinexAPIError}) = true

# Unknown error
isretriable(e::APIsResult{BitfinexAPIError{10000}}) = false

# Generic error
isretriable(e::APIsResult{BitfinexAPIError{10001}}) = false

# Concurrency error
isretriable(e::APIsResult{BitfinexAPIError{10008}}) = false

# Request parameters error
isretriable(e::APIsResult{BitfinexAPIError{10020}}) = false

# Configuration setup failed
isretriable(e::APIsResult{BitfinexAPIError{10050}}) = false

# Failed authentication
isretriable(e::APIsResult{BitfinexAPIError{10100}}) = false

# Error in authentication request payload
isretriable(e::APIsResult{BitfinexAPIError{10111}}) = false

# Error in authentication request signature
isretriable(e::APIsResult{BitfinexAPIError{10112}}) = false

# Error in authentication request encryption
isretriable(e::APIsResult{BitfinexAPIError{10113}}) = false

# Error in authentication request nonce
isretriable(e::APIsResult{BitfinexAPIError{10114}}) = false

# Error in un-authentication request
isretriable(e::APIsResult{BitfinexAPIError{10200}}) = false

# Failed channel subscription
isretriable(e::APIsResult{BitfinexAPIError{10300}}) = false

# Failed channel subscription: already subscribed
isretriable(e::APIsResult{BitfinexAPIError{10301}}) = false

# Failed channel subscription: unknown channel
isretriable(e::APIsResult{BitfinexAPIError{10302}}) = false

# Failed channel subscription: reached limit of open channels
isretriable(e::APIsResult{BitfinexAPIError{10305}}) = false

# Failed channel un-subscription: channel not found
isretriable(e::APIsResult{BitfinexAPIError{10400}}) = false

# Failed channel un-subscription: not subscribed
isretriable(e::APIsResult{BitfinexAPIError{10401}}) = false

# Not ready, try again later
isretriable(e::APIsResult{BitfinexAPIError{11000}}) = true

# Ratelimit error
isretriable(e::APIsResult{BitfinexAPIError{11010}}) = true
retry_timeout(e::APIsResult{BitfinexAPIError{11010}}) = 2
retry_maxcount(e::APIsResult{BitfinexAPIError{11010}}) = 50

# Websocket server stopping, please reconnect later
isretriable(e::APIsResult{BitfinexAPIError{20051}}) = true

# Websocket server resyncing, please reconnect later
isretriable(e::APIsResult{BitfinexAPIError{20060}}) = true

# Websocket server resync complete, please reconnect
isretriable(e::APIsResult{BitfinexAPIError{20061}}) = true

# Info message
isretriable(e::APIsResult{BitfinexAPIError{5000}}) = false
