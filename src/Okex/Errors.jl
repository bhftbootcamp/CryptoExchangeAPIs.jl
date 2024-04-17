# Errors
# https://www.okx.com/docs-v5/en/#error-code-rest-api-public

import ..CryptoAPIs: APIsResult, APIsUndefError
import ..CryptoAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{OkexAPIError}) = true

# SUCCESS
isretriable(e::APIsResult{OkexAPIError{0}}) = false

# Operation failed.
isretriable(e::APIsResult{OkexAPIError{1}}) = false

# Bulk operation partially succeeded.
isretriable(e::APIsResult{OkexAPIError{2}}) = false

# Body for POST request cannot be empty.
isretriable(e::APIsResult{OkexAPIError{50000}}) = false

# Service temporarily unavailable. Try again later
isretriable(e::APIsResult{OkexAPIError{50001}}) = true

# JSON syntax error
isretriable(e::APIsResult{OkexAPIError{50002}}) = false

# API endpoint request timeout (does not mean that the request was successful or failed, please check the request result).
isretriable(e::APIsResult{OkexAPIError{50004}}) = true
retry_timeout(e::APIsResult{OkexAPIError{50004}}) = 5

# API is offline or unavailable.
isretriable(e::APIsResult{OkexAPIError{50005}}) = true
retry_timeout(e::APIsResult{OkexAPIError{50005}}) = 5

# Invalid Content-Type. Please use "application/JSON".
isretriable(e::APIsResult{OkexAPIError{50006}}) = false

# Account blocked.
isretriable(e::APIsResult{OkexAPIError{50007}}) = false

# User does not exist.
isretriable(e::APIsResult{OkexAPIError{50008}}) = false

# Account is suspended due to ongoing liquidation.
isretriable(e::APIsResult{OkexAPIError{50009}}) = false

# User ID cannot be empty.
isretriable(e::APIsResult{OkexAPIError{50010}}) = false

# Rate limit reached. Please refer to API documentation and throttle requests accordingly
isretriable(e::APIsResult{OkexAPIError{50011}}) = true
retry_timeout(e::APIsResult{OkexAPIError{50011}}) = 2
retry_maxcount(e::APIsResult{OkexAPIError{50011}}) = 50

# Account status invalid. Check account status
isretriable(e::APIsResult{OkexAPIError{50012}}) = false

# Systems are busy. Please try again later.
isretriable(e::APIsResult{OkexAPIError{50013}}) = true

# Parameter {param0}} cannot be empty.
isretriable(e::APIsResult{OkexAPIError{50014}}) = false

# Either parameter {param0}} or {param1}} is required.
isretriable(e::APIsResult{OkexAPIError{50015}}) = false

# Parameter {param0}} and {param1}} is an invalid pair.
isretriable(e::APIsResult{OkexAPIError{50016}}) = false

# Position frozen and related operations restricted due to auto-deleveraging (ADL). Try again later
isretriable(e::APIsResult{OkexAPIError{50017}}) = false

# {param0}} frozen and related operations restricted due to auto-deleveraging (ADL). Try again later
isretriable(e::APIsResult{OkexAPIError{50018}}) = false

# Account frozen and related operations restricted due to auto-deleveraging (ADL). Try again later
isretriable(e::APIsResult{OkexAPIError{50019}}) = false

# Position frozen and related operations are restricted due to liquidation. Try again later
isretriable(e::APIsResult{OkexAPIError{50020}}) = false

# {param0}} frozen and related operations are restricted due to liquidation. Try again later
isretriable(e::APIsResult{OkexAPIError{50021}}) = false

# Account frozen and related operations are restricted due to liquidation. Try again later
isretriable(e::APIsResult{OkexAPIError{50022}}) = false

# Funding fees frozen and related operations are restricted. Try again later
isretriable(e::APIsResult{OkexAPIError{50023}}) = false

# Either parameter {param0}} or {param1}} should be submitted.
isretriable(e::APIsResult{OkexAPIError{50024}}) = false

# Parameter {param0}} count exceeds the limit {param1}}.
isretriable(e::APIsResult{OkexAPIError{50025}}) = false

# System error. Try again later
isretriable(e::APIsResult{OkexAPIError{50026}}) = true
retry_timeout(e::APIsResult{OkexAPIError{50026}}) = 5

# This account is restricted from trading. Please contact customer support for assistance.
isretriable(e::APIsResult{OkexAPIError{50027}}) = false

# Unable to take the order, please reach out to support center for details.
isretriable(e::APIsResult{OkexAPIError{50028}}) = false

# Your account has triggered OKX risk control and is temporarily restricted from conducting transactions. Please check your email registered with OKX for contact from our customer support team.
isretriable(e::APIsResult{OkexAPIError{50029}}) = false

# You don't have permission to use this API endpoint
isretriable(e::APIsResult{OkexAPIError{50030}}) = false

# Your account has been set to prohibit transactions in this currency. Please confirm and try again
isretriable(e::APIsResult{OkexAPIError{50032}}) = false

# Instrument blocked. Please verify trading this instrument is allowed under account settings and try again.
isretriable(e::APIsResult{OkexAPIError{50033}}) = false

# This endpoint requires that APIKey must be bound to IP
isretriable(e::APIsResult{OkexAPIError{50035}}) = false

# The expTime can't be earlier than the current system time. Please adjust the expTime and try again.
isretriable(e::APIsResult{OkexAPIError{50036}}) = false

# Order expired.
isretriable(e::APIsResult{OkexAPIError{50037}}) = false

# This feature is unavailable in demo trading
isretriable(e::APIsResult{OkexAPIError{50038}}) = false

# Parameter "before" isn't supported for timestamp pagination
isretriable(e::APIsResult{OkexAPIError{50039}}) = false

# Too frequent operations, please try again later
isretriable(e::APIsResult{OkexAPIError{50040}}) = true

# Your user ID hasn't been whitelisted. Please contact customer service for assistance.
isretriable(e::APIsResult{OkexAPIError{50041}}) = false

# Must select one broker type
isretriable(e::APIsResult{OkexAPIError{50044}}) = false

# {param0}} has already settled. To check the relevant candlestick data, please use {param1}}
isretriable(e::APIsResult{OkexAPIError{50047}}) = false

# No information on the position tier. The current instrument doesn’t support margin trading.
isretriable(e::APIsResult{OkexAPIError{50049}}) = false

# You’ve already activated options trading. Please don’t activate it again.
isretriable(e::APIsResult{OkexAPIError{50050}}) = false

# Due to compliance restrictions in your country or region, you cannot use this feature.
isretriable(e::APIsResult{OkexAPIError{50051}}) = false

# Due to local compliance requirements, trading of this pair is restricted
isretriable(e::APIsResult{OkexAPIError{50052}}) = false

# Instrument ID does not exist.
isretriable(e::APIsResult{OkexAPIError{51001}}) = false

# Timestamp request expired.
isretriable(e::APIsResult{OkexAPIError{50102}}) = true

# Request timed out. Please try again.
isretriable(e::APIsResult{OkexAPIError{51054}}) = true
retry_timeout(e::APIsResult{OkexAPIError{51054}}) = 5
retry_maxcount(e::APIsResult{OkexAPIError{51054}}) = 50
