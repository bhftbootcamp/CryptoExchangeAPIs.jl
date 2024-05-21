# Kraken/Errors
# https://support.kraken.com/hc/en-us/articles/360001491786-API-error-messages

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(e::APIsResult{KrakenAPIError}) = true

# Too many requests
isretriable(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Too many requests")}}) = true
retry_timeout(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Too many requests")}}) = 5
retry_maxcount(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Too many requests")}}) = 50

# Too many requests
isretriable(e::APIsResult{KrakenAPIError{Symbol("EAPI:Rate limit exceeded")}}) = true
retry_timeout(e::APIsResult{KrakenAPIError{Symbol("EAPI:Rate limit exceeded")}}) = 5
retry_maxcount(e::APIsResult{KrakenAPIError{Symbol("EAPI:Rate limit exceeded")}}) = 50

# Internal error
isretriable(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Internal error")}}) = true
retry_timeout(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Internal error")}}) = 20
retry_maxcount(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Internal error")}}) = 10

# Invalid nonce
isretriable(e::APIsResult{KrakenAPIError{Symbol("EAPI:Invalid nonce")}}) = true

# Unknown asset pair
isretriable(e::APIsResult{KrakenAPIError{Symbol("EQuery:Unknown asset pair")}}) = false

# Permission denied
isretriable(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Permission denied")}}) = false

# Invalid arguments
isretriable(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Invalid arguments")}}) = false

# Unknown Method
isretriable(e::APIsResult{KrakenAPIError{Symbol("EGeneral:Unknown Method")}}) = false

# Unavailable
isretriable(e::APIsResult{KrakenAPIError{Symbol("EService:Unavailable")}}) = false

# Market in cancel_only mode
isretriable(e::APIsResult{KrakenAPIError{Symbol("EService:Market in cancel_only mode")}}) = false

# Market in post_only mode
isretriable(e::APIsResult{KrakenAPIError{Symbol("EService:Market in post_only mode")}}) = false

# Deadline elapsed
isretriable(e::APIsResult{KrakenAPIError{Symbol("EService:Deadline elapsed")}}) = false

# Invalid key
isretriable(e::APIsResult{KrakenAPIError{Symbol("EAPI:Invalid key")}}) = false

# Invalid signature
isretriable(e::APIsResult{KrakenAPIError{Symbol("EAPI:Invalid signature")}}) = false

# Bad request
isretriable(e::APIsResult{KrakenAPIError{Symbol("EAPI:Bad request")}}) = false

# Invalid session
isretriable(e::APIsResult{KrakenAPIError{Symbol("ESession:Invalid session")}}) = false

# Cannot open position
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Cannot open position")}}) = false

# Margin allowance exceeded
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Margin allowance exceeded")}}) = false

# Margin level too low
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Margin level too low")}}) = false

# Margin position size exceeded
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Margin position size exceeded")}}) = false

# Insufficient margin
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Insufficient margin")}}) = false

# Insufficient funds
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Insufficient funds")}}) = false

# Order minimum not met
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Order minimum not met")}}) = false

# Cost minimum not met
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Cost minimum not met")}}) = false

# Tick size check failed
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Tick size check failed")}}) = false

# Orders limit exceeded
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Orders limit exceeded")}}) = false

# Rate limit exceeded
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Rate limit exceeded")}}) = true

# Domain rate limit exceeded
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Domain rate limit exceeded")}}) = false

# Positions limit exceede
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Positions limit exceede")}}) = false

# Unknown positio
isretriable(e::APIsResult{KrakenAPIError{Symbol("EOrder:Unknown positio")}}) = false
