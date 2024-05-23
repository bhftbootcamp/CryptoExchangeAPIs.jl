# Errors
# https://deribitexchange.gitbooks.io/deribit-api/content/rpc-errors.html

import ..CryptoAPIs: APIsResult, APIsUndefError
import ..CryptoAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{DeribitAPIError}) = true
retry_timeout(e::APIsResult{DeribitAPIError}) = 1

# INVALID_PARAMS
isretriable(e::APIsResult{DeribitAPIError{-32602}}) = false

# API_NOT_ENABLED
isretriable(e::APIsResult{DeribitAPIError{9999}}) = false

# AUTHORIZATION_REQUIRED
isretriable(e::APIsResult{DeribitAPIError{10000}}) = false

# ERROR
isretriable(e::APIsResult{DeribitAPIError{10001}}) = false

# QTY_TOO_LOW
isretriable(e::APIsResult{DeribitAPIError{10002}}) = false

# ORDER_OVERLAP
isretriable(e::APIsResult{DeribitAPIError{10003}}) = false

# ORDER_NOT_FOUND
isretriable(e::APIsResult{DeribitAPIError{10004}}) = false

# PRICE_TOO_LOW
isretriable(e::APIsResult{DeribitAPIError{10005}}) = false

# PRICE_TOO_LOW4IDX
isretriable(e::APIsResult{DeribitAPIError{10006}}) = false

# PRICE_TOO_HIGH
isretriable(e::APIsResult{DeribitAPIError{10007}}) = false

# PRICE_TOO_HIGH4IDX
isretriable(e::APIsResult{DeribitAPIError{10008}}) = false

# NOT_ENOUGH_FUNDS
isretriable(e::APIsResult{DeribitAPIError{10009}}) = false

# ALREADY_CLOSED
isretriable(e::APIsResult{DeribitAPIError{10010}}) = true

# PRICE_NOT_ALLOWED
isretriable(e::APIsResult{DeribitAPIError{10011}}) = false

# BOOK_CLOSED
isretriable(e::APIsResult{DeribitAPIError{10012}}) = false

# PME_MAX_TOTAL_OPEN_ORDERS
isretriable(e::APIsResult{DeribitAPIError{10013}}) = false

# PME_MAX_FUTURE_OPEN_ORDERS
isretriable(e::APIsResult{DeribitAPIError{10014}}) = false

# PME_MAX_OPTION_OPEN_ORDERS
isretriable(e::APIsResult{DeribitAPIError{10015}}) = false

# PME_MAX_FUTURE_OPEN_ORDERS_SIZE
isretriable(e::APIsResult{DeribitAPIError{10016}}) = false

# PME_MAX_OPTION_OPEN_ORDERS_SIZE
isretriable(e::APIsResult{DeribitAPIError{10017}}) = false

# LOCKED_BY_ADMIN
isretriable(e::APIsResult{DeribitAPIError{10019}}) = false

# INVALID_OR_UNSUPPORTED_INSTRUMENT
isretriable(e::APIsResult{DeribitAPIError{10020}}) = false

# INVALID_QUANTITY
isretriable(e::APIsResult{DeribitAPIError{10022}}) = false

# INVALID_PRICE
isretriable(e::APIsResult{DeribitAPIError{10023}}) = false

# INVALID_MAX_SHOW
isretriable(e::APIsResult{DeribitAPIError{10024}}) = false

# INVALID_ORDER_ID
isretriable(e::APIsResult{DeribitAPIError{10025}}) = false

# PRICE_PRECISION_EXCEEDED
isretriable(e::APIsResult{DeribitAPIError{10026}}) = false

# NON_INTEGER_CONTRACT_AMOUNT
isretriable(e::APIsResult{DeribitAPIError{10027}}) = false

# TOO_MANY_REQUESTS
isretriable(e::APIsResult{DeribitAPIError{10028}}) = true
retry_timeout(e::APIsResult{DeribitAPIError{10028}}) = 2
retry_maxcount(e::APIsResult{DeribitAPIError{10028}}) = 50

# NOT_OWNER_OF_ORDER
isretriable(e::APIsResult{DeribitAPIError{10029}}) = false

# MUST_BE_WEBSOCKET_REQUEST
isretriable(e::APIsResult{DeribitAPIError{10030}}) = false

# INVALID_ARGS_FOR_INSTRUMENT
isretriable(e::APIsResult{DeribitAPIError{10031}}) = false

# WHOLE_COST_TOO_LOW
isretriable(e::APIsResult{DeribitAPIError{10032}}) = false

# NOT_IMPLEMENTED
isretriable(e::APIsResult{DeribitAPIError{10033}}) = false

# STOP_PRICE_TOO_HIGH
isretriable(e::APIsResult{DeribitAPIError{10034}}) = false

# STOP_PRICE_TOO_LOW
isretriable(e::APIsResult{DeribitAPIError{10035}}) = false

# NO_MORE_STOPS
isretriable(e::APIsResult{DeribitAPIError{11035}}) = false

# INVALID_STOPPX_FOR_INDEX_OR_LAST
isretriable(e::APIsResult{DeribitAPIError{11036}}) = false

# OUTDATED_INSTRUMENT_FOR_IV_ORDER
isretriable(e::APIsResult{DeribitAPIError{11037}}) = false

# NO_ADV_FOR_FUTURES
isretriable(e::APIsResult{DeribitAPIError{11038}}) = false

# NO_ADV_POSTONLY
isretriable(e::APIsResult{DeribitAPIError{11039}}) = false

# IMPV_NOT_IN_RANGE_0..499%
isretriable(e::APIsResult{DeribitAPIError{11040}}) = false

# NOT_ADV_ORDER
isretriable(e::APIsResult{DeribitAPIError{11041}}) = false

# PERMISSION_DENIED
isretriable(e::APIsResult{DeribitAPIError{11042}}) = false

# NOT_OPEN_ORDER
isretriable(e::APIsResult{DeribitAPIError{11044}}) = false

# INVALID_EVENT
isretriable(e::APIsResult{DeribitAPIError{11045}}) = false

# OUTDATED_INSTRUMENT
isretriable(e::APIsResult{DeribitAPIError{11046}}) = false

# UNSUPPORTED_ARG_COMBINATION
isretriable(e::APIsResult{DeribitAPIError{11047}}) = false

# NOT_ON_THIS_SERVER
isretriable(e::APIsResult{DeribitAPIError{11048}}) = true

# INVALID_REQUEST
isretriable(e::APIsResult{DeribitAPIError{11050}}) = false

# SYSTEM_MAINTENANCE
isretriable(e::APIsResult{DeribitAPIError{11051}}) = false

# OTHER_REJECT
isretriable(e::APIsResult{DeribitAPIError{11030}}) = true

# OTHER_ERROR
isretriable(e::APIsResult{DeribitAPIError{11031}}) = true
