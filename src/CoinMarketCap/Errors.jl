# CoinMarketCap/Errors
# https://coinmarketcap.com/api/documentation/v1/#section/Errors-and-Rate-Limits 

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{CoinMarketCapAPIError}) = true

# Success
isretriable(e::APIsResult{CoinMarketCapAPIError{0}}) = false

# Too Many Requests
isretriable(e::APIsResult{CoinMarketCapAPIError{1010}}) = true
retry_timeout(e::APIsResult{CoinMarketCapAPIError{1010}}) = 10
retry_maxcount(e::APIsResult{CoinMarketCapAPIError{1010}}) = 50

#Invalid key
isretriable(e::APIsResult{CoinMarketCapAPIError{1001}}) = false

#Key missing
isretriable(e::APIsResult{CoinMarketCapAPIError{1002}}) = false

#Key Subscription plan expired
isretriable(e::APIsResult{CoinMarketCapAPIError{1004}}) = false

#Key Required
isretriable(e::APIsResult{CoinMarketCapAPIError{1005}}) = false

#Key disabled 
isretriable(e::APIsResult{CoinMarketCapAPIError{1007}}) = false
