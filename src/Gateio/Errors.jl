# Gateio/Errors
# https://www.gate.io/docs/developers/apiv4/en/#error-handling

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{GateioAPIError}) = true

# TOO_MANY_REQUESTS
isretriable(e::APIsResult{GateioAPIError{:TOO_MANY_REQUESTS}}) = true
retry_timeout(e::APIsResult{GateioAPIError{:TOO_MANY_REQUESTS}}) = 2
retry_maxcount(e::APIsResult{GateioAPIError{:TOO_MANY_REQUESTS}}) = 50

# INVALID_PARAM_VALUE
isretriable(e::APIsResult{GateioAPIError{:INVALID_PARAM_VALUE}}) = false

# INVALID_PROTOCOL
isretriable(e::APIsResult{GateioAPIError{:INVALID_PROTOCOL}}) = false

# INVALID_ARGUMENT
isretriable(e::APIsResult{GateioAPIError{:INVALID_ARGUMENT}}) = false

# INVALID_REQUEST_BODY
isretriable(e::APIsResult{GateioAPIError{:INVALID_REQUEST_BODY}}) = false

# MISSING_REQUIRED_PARAM
isretriable(e::APIsResult{GateioAPIError{:MISSING_REQUIRED_PARAM}}) = false

# BAD_REQUEST
isretriable(e::APIsResult{GateioAPIError{:BAD_REQUEST}}) = false

# INVALID_CONTENT_TYPE
isretriable(e::APIsResult{GateioAPIError{:INVALID_CONTENT_TYPE}}) = false

# NOT_ACCEPTABLE
isretriable(e::APIsResult{GateioAPIError{:NOT_ACCEPTABLE}}) = false

# METHOD_NOT_ALLOWED
isretriable(e::APIsResult{GateioAPIError{:METHOD_NOT_ALLOWED}}) = false

# NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:NOT_FOUND}}) = false

# INVALID_CREDENTIALS
isretriable(e::APIsResult{GateioAPIError{:INVALID_CREDENTIALS}}) = false

# INVALID_KEY
isretriable(e::APIsResult{GateioAPIError{:INVALID_KEY}}) = false

# IP_FORBIDDEN
isretriable(e::APIsResult{GateioAPIError{:IP_FORBIDDEN}}) = false

# READ_ONLY
isretriable(e::APIsResult{GateioAPIError{:READ_ONLY}}) = false

# INVALID_SIGNATURE
isretriable(e::APIsResult{GateioAPIError{:INVALID_SIGNATURE}}) = false

# MISSING_REQUIRED_HEADER
isretriable(e::APIsResult{GateioAPIError{:MISSING_REQUIRED_HEADER}}) = false

# REQUEST_EXPIRED
isretriable(e::APIsResult{GateioAPIError{:REQUEST_EXPIRED}}) = false

# ACCOUNT_LOCKED
isretriable(e::APIsResult{GateioAPIError{:ACCOUNT_LOCKED}}) = false

# FORBIDDEN
isretriable(e::APIsResult{GateioAPIError{:FORBIDDEN}}) = false

# SUB_ACCOUNT_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:SUB_ACCOUNT_NOT_FOUND}}) = false

# SUB_ACCOUNT_LOCKED
isretriable(e::APIsResult{GateioAPIError{:SUB_ACCOUNT_LOCKED}}) = false

# MARGIN_BALANCE_EXCEPTION
isretriable(e::APIsResult{GateioAPIError{:MARGIN_BALANCE_EXCEPTION}}) = false

# MARGIN_TRANSFER_FAILED
isretriable(e::APIsResult{GateioAPIError{:MARGIN_TRANSFER_FAILED}}) = false

# TOO_MUCH_FUTURES_AVAILABLE
isretriable(e::APIsResult{GateioAPIError{:TOO_MUCH_FUTURES_AVAILABLE}}) = false

# FUTURES_BALANCE_NOT_ENOUGH
isretriable(e::APIsResult{GateioAPIError{:FUTURES_BALANCE_NOT_ENOUGH}}) = false

# ACCOUNT_EXCEPTION
isretriable(e::APIsResult{GateioAPIError{:ACCOUNT_EXCEPTION}}) = false

# SUB_ACCOUNT_TRANSFER_FAILED
isretriable(e::APIsResult{GateioAPIError{:SUB_ACCOUNT_TRANSFER_FAILED}}) = false

# ADDRESS_NOT_USED
isretriable(e::APIsResult{GateioAPIError{:ADDRESS_NOT_USED}}) = false

# TOO_FAST
isretriable(e::APIsResult{GateioAPIError{:TOO_FAST}}) = true

# WITHDRAWAL_OVER_LIMIT
isretriable(e::APIsResult{GateioAPIError{:WITHDRAWAL_OVER_LIMIT}}) = false

# API_WITHDRAW_DISABLED
isretriable(e::APIsResult{GateioAPIError{:API_WITHDRAW_DISABLED}}) = false

# INVALID_WITHDRAW_ID
isretriable(e::APIsResult{GateioAPIError{:INVALID_WITHDRAW_ID}}) = false

# INVALID_WITHDRAW_CANCEL_STATUS
isretriable(e::APIsResult{GateioAPIError{:INVALID_WITHDRAW_CANCEL_STATUS}}) = false

# DUPLICATE_REQUEST
isretriable(e::APIsResult{GateioAPIError{:DUPLICATE_REQUEST}}) = false

# ORDER_EXISTS
isretriable(e::APIsResult{GateioAPIError{:ORDER_EXISTS}}) = false

# INVALID_CLIENT_ORDER_ID
isretriable(e::APIsResult{GateioAPIError{:INVALID_CLIENT_ORDER_ID}}) = false

# INVALID_PRECISION
isretriable(e::APIsResult{GateioAPIError{:INVALID_PRECISION}}) = false

# INVALID_CURRENCY
isretriable(e::APIsResult{GateioAPIError{:INVALID_CURRENCY}}) = false

# INVALID_CURRENCY_PAIR
isretriable(e::APIsResult{GateioAPIError{:INVALID_CURRENCY_PAIR}}) = false

# POC_FILL_IMMEDIATELY
isretriable(e::APIsResult{GateioAPIError{:POC_FILL_IMMEDIATELY}}) = false

# ORDER_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:ORDER_NOT_FOUND}}) = false

# ORDER_CLOSED
isretriable(e::APIsResult{GateioAPIError{:ORDER_CLOSED}}) = false

# ORDER_CANCELLED
isretriable(e::APIsResult{GateioAPIError{:ORDER_CANCELLED}}) = false

# QUANTITY_NOT_ENOUGH
isretriable(e::APIsResult{GateioAPIError{:QUANTITY_NOT_ENOUGH}}) = false

# BALANCE_NOT_ENOUGH
isretriable(e::APIsResult{GateioAPIError{:BALANCE_NOT_ENOUGH}}) = false

# MARGIN_NOT_SUPPORTED
isretriable(e::APIsResult{GateioAPIError{:MARGIN_NOT_SUPPORTED}}) = false

# MARGIN_BALANCE_NOT_ENOUGH
isretriable(e::APIsResult{GateioAPIError{:MARGIN_BALANCE_NOT_ENOUGH}}) = false

# AMOUNT_TOO_LITTLE
isretriable(e::APIsResult{GateioAPIError{:AMOUNT_TOO_LITTLE}}) = false

# AMOUNT_TOO_MUCH
isretriable(e::APIsResult{GateioAPIError{:AMOUNT_TOO_MUCH}}) = false

# REPEATED_CREATION
isretriable(e::APIsResult{GateioAPIError{:REPEATED_CREATION}}) = false

# LOAN_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:LOAN_NOT_FOUND}}) = false

# LOAN_RECORD_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:LOAN_RECORD_NOT_FOUND}}) = false

# NO_MATCHED_LOAN
isretriable(e::APIsResult{GateioAPIError{:NO_MATCHED_LOAN}}) = false

# NOT_MERGEABLE
isretriable(e::APIsResult{GateioAPIError{:NOT_MERGEABLE}}) = false

# REPAY_TOO_MUCH
isretriable(e::APIsResult{GateioAPIError{:REPAY_TOO_MUCH}}) = true

# TOO_MANY_CURRENCY_PAIRS
isretriable(e::APIsResult{GateioAPIError{:TOO_MANY_CURRENCY_PAIRS}}) = false

# MIXED_ACCOUNT_TYPE
isretriable(e::APIsResult{GateioAPIError{:MIXED_ACCOUNT_TYPE}}) = false

# AUTO_BORROW_TOO_MUCH
isretriable(e::APIsResult{GateioAPIError{:AUTO_BORROW_TOO_MUCH}}) = false

# TRADE_RESTRICTED
isretriable(e::APIsResult{GateioAPIError{:TRADE_RESTRICTED}}) = false

# FOK_NOT_FILL
isretriable(e::APIsResult{GateioAPIError{:FOK_NOT_FILL}}) = false

# INITIAL_MARGIN_TOO_LOW
isretriable(e::APIsResult{GateioAPIError{:INITIAL_MARGIN_TOO_LOW}}) = false

# NO_MERGEABLE_ORDERS
isretriable(e::APIsResult{GateioAPIError{:NO_MERGEABLE_ORDERS}}) = false

# ORDER_BOOK_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:ORDER_BOOK_NOT_FOUND}}) = false

# FAILED_RETRIEVE_ASSETS
isretriable(e::APIsResult{GateioAPIError{:FAILED_RETRIEVE_ASSETS}}) = false

# USER_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:USER_NOT_FOUND}}) = false

# CONTRACT_NO_COUNTER
isretriable(e::APIsResult{GateioAPIError{:CONTRACT_NO_COUNTER}}) = false

# CONTRACT_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:CONTRACT_NOT_FOUND}}) = false

# RISK_LIMIT_EXCEEDED
isretriable(e::APIsResult{GateioAPIError{:RISK_LIMIT_EXCEEDED}}) = false

# INSUFFICIENT_AVAILABLE
isretriable(e::APIsResult{GateioAPIError{:INSUFFICIENT_AVAILABLE}}) = false

# LIQUIDATE_IMMEDIATELY
isretriable(e::APIsResult{GateioAPIError{:LIQUIDATE_IMMEDIATELY}}) = false

# LEVERAGE_TOO_HIGH
isretriable(e::APIsResult{GateioAPIError{:LEVERAGE_TOO_HIGH}}) = false

# LEVERAGE_TOO_LOW
isretriable(e::APIsResult{GateioAPIError{:LEVERAGE_TOO_LOW}}) = false

# ORDER_NOT_OWNED
isretriable(e::APIsResult{GateioAPIError{:ORDER_NOT_OWNED}}) = false

# ORDER_FINISHED
isretriable(e::APIsResult{GateioAPIError{:ORDER_FINISHED}}) = false

# TOO_MANY_ORDERS
isretriable(e::APIsResult{GateioAPIError{:TOO_MANY_ORDERS}}) = false

# POSITION_CROSS_MARGIN
isretriable(e::APIsResult{GateioAPIError{:POSITION_CROSS_MARGIN}}) = false

# POSITION_IN_LIQUIDATION
isretriable(e::APIsResult{GateioAPIError{:POSITION_IN_LIQUIDATION}}) = false

# POSITION_IN_CLOSE
isretriable(e::APIsResult{GateioAPIError{:POSITION_IN_CLOSE}}) = false

# POSITION_EMPTY
isretriable(e::APIsResult{GateioAPIError{:POSITION_EMPTY}}) = false

# REMOVE_TOO_MUCH
isretriable(e::APIsResult{GateioAPIError{:REMOVE_TOO_MUCH}}) = false

# RISK_LIMIT_NOT_MULTIPLE
isretriable(e::APIsResult{GateioAPIError{:RISK_LIMIT_NOT_MULTIPLE}}) = false

# RISK_LIMIT_TOO_HIGH
isretriable(e::APIsResult{GateioAPIError{:RISK_LIMIT_TOO_HIGH}}) = false

# RISK_LIMIT_TOO_lOW
isretriable(e::APIsResult{GateioAPIError{:RISK_LIMIT_TOO_lOW}}) = false

# PRICE_TOO_DEVIATED
isretriable(e::APIsResult{GateioAPIError{:PRICE_TOO_DEVIATED}}) = false

# SIZE_TOO_LARGE
isretriable(e::APIsResult{GateioAPIError{:SIZE_TOO_LARGE}}) = false

# SIZE_TOO_SMALL
isretriable(e::APIsResult{GateioAPIError{:SIZE_TOO_SMALL}}) = false

# PRICE_OVER_LIQUIDATION
isretriable(e::APIsResult{GateioAPIError{:PRICE_OVER_LIQUIDATION}}) = false

# PRICE_OVER_BANKRUPT
isretriable(e::APIsResult{GateioAPIError{:PRICE_OVER_BANKRUPT}}) = false

# ORDER_POC_IMMEDIATE
isretriable(e::APIsResult{GateioAPIError{:ORDER_POC_IMMEDIATE}}) = false

# INCREASE_POSITION
isretriable(e::APIsResult{GateioAPIError{:INCREASE_POSITION}}) = false

# CONTRACT_IN_DELISTING
isretriable(e::APIsResult{GateioAPIError{:CONTRACT_IN_DELISTING}}) = false

# POSITION_NOT_FOUND
isretriable(e::APIsResult{GateioAPIError{:POSITION_NOT_FOUND}}) = false

# POSITION_DUAL_MODE
isretriable(e::APIsResult{GateioAPIError{:POSITION_DUAL_MODE}}) = false

# ORDER_PENDING
isretriable(e::APIsResult{GateioAPIError{:ORDER_PENDING}}) = false

# POSITION_HOLDING
isretriable(e::APIsResult{GateioAPIError{:POSITION_HOLDING}}) = false

# REDUCE_EXCEEDED
isretriable(e::APIsResult{GateioAPIError{:REDUCE_EXCEEDED}}) = false

# NO_CHANGE
isretriable(e::APIsResult{GateioAPIError{:NO_CHANGE}}) = false

# AMEND_WITH_STOP
isretriable(e::APIsResult{GateioAPIError{:AMEND_WITH_STOP}}) = false

# ORDER_FOK
isretriable(e::APIsResult{GateioAPIError{:ORDER_FOK}}) = false

# INTERNAL
isretriable(e::APIsResult{GateioAPIError{:INTERNAL}}) = true

# SERVER_ERROR
isretriable(e::APIsResult{GateioAPIError{:SERVER_ERROR}}) = true

# TOO_BUSY
isretriable(e::APIsResult{GateioAPIError{:TOO_BUSY}}) = true
