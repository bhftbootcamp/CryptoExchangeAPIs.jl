# Binance/Errors
# https://github.com/binance/binance-spot-api-docs/blob/master/errors.md

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{BinanceAPIError}) = true

# UNKNOWN
isretriable(e::APIsResult{BinanceAPIError{-1000}}) = false

# DISCONNECTED
isretriable(e::APIsResult{BinanceAPIError{-1001}}) = true

# UNAUTHORIZED
isretriable(e::APIsResult{BinanceAPIError{-1002}}) = false

# TOO_MANY_REQUESTS
isretriable(e::APIsResult{BinanceAPIError{-1003}}) = true
retry_timeout(e::APIsResult{BinanceAPIError{-1003}}) = e.response.headers.retry_after
retry_maxcount(e::APIsResult{BinanceAPIError{-1003}}) = 25

# UNEXPECTED_RESP
isretriable(e::APIsResult{BinanceAPIError{-1006}}) = false

# TIMEOUT
isretriable(e::APIsResult{BinanceAPIError{-1007}}) = true

# SERVER_BUSY
isretriable(e::APIsResult{BinanceAPIError{-1008}}) = true

# UNKNOWN_ORDER_COMPOSITION
isretriable(e::APIsResult{BinanceAPIError{-1014}}) = false

# TOO_MANY_ORDERS
isretriable(e::APIsResult{BinanceAPIError{-1015}}) = false

# SERVICE_SHUTTING_DOWN
isretriable(e::APIsResult{BinanceAPIError{-1016}}) = false

# UNSUPPORTED_OPERATION
isretriable(e::APIsResult{BinanceAPIError{-1020}}) = false

# INVALID_TIMESTAMP
isretriable(e::APIsResult{BinanceAPIError{-1021}}) = true

# INVALID_SIGNATURE
isretriable(e::APIsResult{BinanceAPIError{-1022}}) = false

# ILLEGAL_CHARS
isretriable(e::APIsResult{BinanceAPIError{-1100}}) = false

# TOO_MANY_PARAMETERS
isretriable(e::APIsResult{BinanceAPIError{-1101}}) = false

# MANDATORY_PARAM_EMPTY_OR_MALFORMED
isretriable(e::APIsResult{BinanceAPIError{-1102}}) = false

# UNKNOWN_PARAM
isretriable(e::APIsResult{BinanceAPIError{-1103}}) = false

# UNREAD_PARAMETERS
isretriable(e::APIsResult{BinanceAPIError{-1104}}) = false

# PARAM_EMPTY
isretriable(e::APIsResult{BinanceAPIError{-1105}}) = false

# PARAM_NOT_REQUIRED
isretriable(e::APIsResult{BinanceAPIError{-1106}}) = false

# PARAM_OVERFLOW
isretriable(e::APIsResult{BinanceAPIError{-1108}}) = false

# BAD_PRECISION
isretriable(e::APIsResult{BinanceAPIError{-1111}}) = false

# NO_DEPTH
isretriable(e::APIsResult{BinanceAPIError{-1112}}) = false

# TIF_NOT_REQUIRED
isretriable(e::APIsResult{BinanceAPIError{-1114}}) = false

# INVALID_TIF
isretriable(e::APIsResult{BinanceAPIError{-1115}}) = false

# INVALID_ORDER_TYPE
isretriable(e::APIsResult{BinanceAPIError{-1116}}) = false

# INVALID_SIDE
isretriable(e::APIsResult{BinanceAPIError{-1117}}) = false

# EMPTY_NEW_CL_ORD_ID
isretriable(e::APIsResult{BinanceAPIError{-1118}}) = false

# EMPTY_ORG_CL_ORD_ID
isretriable(e::APIsResult{BinanceAPIError{-1119}}) = false

# BAD_INTERVAL
isretriable(e::APIsResult{BinanceAPIError{-1120}}) = false

# BAD_SYMBOL
isretriable(e::APIsResult{BinanceAPIError{-1121}}) = false

# INVALID_LISTEN_KEY
isretriable(e::APIsResult{BinanceAPIError{-1125}}) = false

# MORE_THAN_XX_HOURS
isretriable(e::APIsResult{BinanceAPIError{-1127}}) = false

# OPTIONAL_PARAMS_BAD_COMBO
isretriable(e::APIsResult{BinanceAPIError{-1128}}) = false

# INVALID_PARAMETER
isretriable(e::APIsResult{BinanceAPIError{-1130}}) = false

# BAD_STRATEGY_TYPE
isretriable(e::APIsResult{BinanceAPIError{-1134}}) = false

# INVALID_JSON
isretriable(e::APIsResult{BinanceAPIError{-1135}}) = false

# INVALID_CANCEL_RESTRICTIONS
isretriable(e::APIsResult{BinanceAPIError{-1145}}) = false

# NEW_ORDER_REJECTED
isretriable(e::APIsResult{BinanceAPIError{-2010}}) = false

# CANCEL_REJECTED
isretriable(e::APIsResult{BinanceAPIError{-2011}}) = false

# NO_SUCH_ORDER
isretriable(e::APIsResult{BinanceAPIError{-2013}}) = false

# BAD_API_KEY_FMT
isretriable(e::APIsResult{BinanceAPIError{-2014}}) = false

# REJECTED_MBX_KEY
isretriable(e::APIsResult{BinanceAPIError{-2015}}) = false

# NO_TRADING_WINDOW
isretriable(e::APIsResult{BinanceAPIError{-2016}}) = false

# ORDER_ARCHIVED
isretriable(e::APIsResult{BinanceAPIError{-2026}}) = false
