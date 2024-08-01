# Errors
# https://api-docs.aevo.xyz/reference/errors

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNHANDLED
isretriable(::APIsResult{AevoAPIError}) = true

# UNKNOWN
isretriable(e::APIsResult{AevoAPIError{Symbol("UNKNOWN")}}) = false

# TIMED_OUT
isretriable(e::APIsResult{AevoAPIError{Symbol("TIMED_OUT")}}) = true

# BAD_REQUEST
isretriable(e::APIsResult{AevoAPIError{Symbol("BAD_REQUEST")}}) = false

# ASSET_INVALID
isretriable(e::APIsResult{AevoAPIError{Symbol("ASSET_INVALID")}}) = false

# AMOUNT_STEP_SIZE_NOT_WITHIN_RANGE
isretriable(e::APIsResult{AevoAPIError{Symbol("AMOUNT_STEP_SIZE_NOT_WITHIN_RANGE")}}) = false

# INSTRUMENT_DELISTING
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_DELISTING")}}) = false

# INSTRUMENT_EXPIRED
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_EXPIRED")}}) = false

# INSTRUMENT_ID_INVALID
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_ID_INVALID")}}) = false

# INSTRUMENT_INACTIVE
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_INACTIVE")}}) = false

# INSTRUMENT_INVALID
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_INVALID")}}) = false

# INSTRUMENT_NOT_FOUND
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_NOT_FOUND")}}) = false

# INSTRUMENT_NOT_PERPETUAL
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_NOT_PERPETUAL")}}) = false

# INSTRUMENT_PAUSED
isretriable(e::APIsResult{AevoAPIError{Symbol("INSTRUMENT_PAUSED")}}) = false

# INVALID_INSTRUMENT
isretriable(e::APIsResult{AevoAPIError{Symbol("INVALID_INSTRUMENT")}}) = false

# INVALID_PERPETUAL_NAME
isretriable(e::APIsResult{AevoAPIError{Symbol("INVALID_PERPETUAL_NAME")}}) = false

# INVALID_RANGE
isretriable(e::APIsResult{AevoAPIError{Symbol("INVALID_RANGE")}}) = false

# INVALID_TIMESTAMP
isretriable(e::APIsResult{AevoAPIError{Symbol("INVALID_TIMESTAMP")}}) = false

# MISSING_FROM
isretriable(e::APIsResult{AevoAPIError{Symbol("MISSING_FROM")}}) = false

# MISSING_LIMIT
isretriable(e::APIsResult{AevoAPIError{Symbol("MISSING_LIMIT")}}) = false

# MISSING_START
isretriable(e::APIsResult{AevoAPIError{Symbol("MISSING_START")}}) = false

# MISSING_SYMBOL
isretriable(e::APIsResult{AevoAPIError{Symbol("MISSING_SYMBOL")}}) = false