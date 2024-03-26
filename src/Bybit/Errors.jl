# Errors
# https://bybit-exchange.github.io/docs/v5/error

import ..CryptoAPIs: APIsResult, APIsUndefError, isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(::APIsResult{BybitAPIError}) = true

# Success
isretriable(e::APIsResult{BybitAPIError{0}}) = false

# Server Timeout
isretriable(e::APIsResult{BybitAPIError{10000}}) = true
retry_timeout(e::APIsResult{BybitAPIError{10000}}) = 10
retry_maxcount(e::APIsResult{BybitAPIError{10000}}) = 50

# Not supported symbols
isretriable(e::APIsResult{BybitAPIError{12810}}) = false

# Request parameter error
isretriable(e::APIsResult{BybitAPIError{10001}}) = false

# The request time exceeds the time window range.
isretriable(e::APIsResult{BybitAPIError{10002}}) = true

# API key is invalid.
isretriable(e::APIsResult{BybitAPIError{10003}}) = false

# Error sign, please check your signature generation algorithm.
isretriable(e::APIsResult{BybitAPIError{10004}}) = false

# Permission denied, please check your API key permissions.
isretriable(e::APIsResult{BybitAPIError{10005}}) = false

# Too many visits. Exceeded the API Rate Limit.
isretriable(e::APIsResult{BybitAPIError{10006}}) = true
function retry_timeout(e::APIsResult{BybitAPIError{10006}})
    diff = e.http_headers.x_bapi_limit_reset_timestamp - e.http_headers.timenow
    return value(convert(Nanosecond, diff)) * 1e-9
end
retry_maxcount(e::APIsResult{BybitAPIError{10006}}) = 50

# User authentication failed.
isretriable(e::APIsResult{BybitAPIError{10007}}) = false

# Common banned, please check your account mode
isretriable(e::APIsResult{BybitAPIError{10008}}) = false

# IP has been banned.
isretriable(e::APIsResult{BybitAPIError{10009}}) = false

# Unmatched IP, please check your API key's bound IP addresses.
isretriable(e::APIsResult{BybitAPIError{10010}}) = false

# Invalid duplicate request.
isretriable(e::APIsResult{BybitAPIError{10014}}) = false

# Server error.
isretriable(e::APIsResult{BybitAPIError{10016}}) = true

# Route not found.
isretriable(e::APIsResult{BybitAPIError{10017}}) = false

# Exceeded the IP Rate Limit.
isretriable(e::APIsResult{BybitAPIError{10018}}) = true

# Compliance rules triggered
isretriable(e::APIsResult{BybitAPIError{10024}}) = false

# Transactions are banned.
isretriable(e::APIsResult{BybitAPIError{10027}}) = false

# The requested symbol is invalid, please check symbol whitelist
isretriable(e::APIsResult{BybitAPIError{10029}}) = false

# The API can only be accessed by unified account users.
isretriable(e::APIsResult{BybitAPIError{10028}}) = false

# The order is modified during the process of replacing , please check the order status again
isretriable(e::APIsResult{BybitAPIError{40004}}) = false

# The API cannot be accessed by unified account users.
isretriable(e::APIsResult{BybitAPIError{100028}}) = false

# Order does not exist
isretriable(e::APIsResult{BybitAPIError{110001}}) = false

# Order price exceeds the allowable range.
isretriable(e::APIsResult{BybitAPIError{110003}}) = false

# Wallet balance is insufficient
isretriable(e::APIsResult{BybitAPIError{110004}}) = false

# Position status
isretriable(e::APIsResult{BybitAPIError{110005}}) = false

# The assets are estimated to be unable to cover the position margin
isretriable(e::APIsResult{BybitAPIError{110006}}) = false

# Available balance is insufficient
isretriable(e::APIsResult{BybitAPIError{110007}}) = false

# The order has been completed or cancelled.
isretriable(e::APIsResult{BybitAPIError{110008}}) = false

# The number of stop orders exceeds the maximum allowable limit. You can find references from our Open API doc.
isretriable(e::APIsResult{BybitAPIError{110009}}) = false

# The order has been cancelled
isretriable(e::APIsResult{BybitAPIError{110010}}) = false

# Liquidation will be triggered immediately by this adjustment
isretriable(e::APIsResult{BybitAPIError{110011}}) = false

# Insufficient available balance.
isretriable(e::APIsResult{BybitAPIError{110012}}) = false

# Cannot set leverage due to risk limit level.
isretriable(e::APIsResult{BybitAPIError{110013}}) = false

# Insufficient available balance to add additional margin.
isretriable(e::APIsResult{BybitAPIError{110014}}) = false

# The position is in cross margin mode.
isretriable(e::APIsResult{BybitAPIError{110015}}) = false

# The quantity of contracts requested exceeds the risk limit, please adjust your risk limit level before trying again
isretriable(e::APIsResult{BybitAPIError{110016}}) = false

# Unmatch the ReduceOnly rules.
isretriable(e::APIsResult{BybitAPIError{110017}}) = false

# User ID is illegal.
isretriable(e::APIsResult{BybitAPIError{110018}}) = false

# Order ID is illegal.
isretriable(e::APIsResult{BybitAPIError{110019}}) = false

# Not allowed to have more than 500 active orders.
isretriable(e::APIsResult{BybitAPIError{110020}}) = false

# Not allowed to exceeded position limits due to Open Interest.
isretriable(e::APIsResult{BybitAPIError{110021}}) = false

# Quantity has been restricted and orders cannot be modified to increase the quantity.
isretriable(e::APIsResult{BybitAPIError{110022}}) = false

# Currently you can only reduce your position on this contract. please check our announcement or contact customer service for details.
isretriable(e::APIsResult{BybitAPIError{110023}}) = false

# You have an existing position, so the position mode cannot be switched.
isretriable(e::APIsResult{BybitAPIError{110024}}) = false

# Position mode has not been modified.
isretriable(e::APIsResult{BybitAPIError{110025}}) = false

# Cross/isolated margin mode has not been modified.
isretriable(e::APIsResult{BybitAPIError{110026}}) = false

# Margin has not been modified.
isretriable(e::APIsResult{BybitAPIError{110027}}) = false

# You have existing open orders, so the position mode cannot be switched.
isretriable(e::APIsResult{BybitAPIError{110028}}) = false

# Hedge mode is not supported for this symbol.
isretriable(e::APIsResult{BybitAPIError{110029}}) = false

# Duplicate orderId
isretriable(e::APIsResult{BybitAPIError{110030}}) = false

# Non-existing risk limit info, please check the risk limit rules.
isretriable(e::APIsResult{BybitAPIError{110031}}) = false

# Order is illegal
isretriable(e::APIsResult{BybitAPIError{110032}}) = false

# You can't set margin without an open position
isretriable(e::APIsResult{BybitAPIError{110033}}) = false

# There is no net position
isretriable(e::APIsResult{BybitAPIError{110034}}) = false

# Cancellation of orders was not completed before liquidation
isretriable(e::APIsResult{BybitAPIError{110035}}) = false

# You are not allowed to change leverage due to cross margin mode.
isretriable(e::APIsResult{BybitAPIError{110036}}) = false

# User setting list does not have this symbol
isretriable(e::APIsResult{BybitAPIError{110037}}) = false

# You are not allowed to change leverage due to portfolio margin mode.
isretriable(e::APIsResult{BybitAPIError{110038}}) = false

# Maintenance margin rate is too high. This may trigger liquidation.
isretriable(e::APIsResult{BybitAPIError{110039}}) = false

# The order will trigger a forced liquidation, please re-submit the order.
isretriable(e::APIsResult{BybitAPIError{110040}}) = false

# Skip liquidation is not allowed when a position or maker order exists
isretriable(e::APIsResult{BybitAPIError{110041}}) = false

# Currently,due to pre-delivery status, you can only reduce your position on this contract.
isretriable(e::APIsResult{BybitAPIError{110042}}) = false

# Set leverage has not been modified.
isretriable(e::APIsResult{BybitAPIError{110043}}) = false

# Available margin is insufficient.
isretriable(e::APIsResult{BybitAPIError{110044}}) = false

# Wallet balance is insufficient.
isretriable(e::APIsResult{BybitAPIError{110045}}) = false

# Liquidation will be triggered immediately by this adjustment.
isretriable(e::APIsResult{BybitAPIError{110046}}) = false

# Risk limit cannot be adjusted due to insufficient available margin.
isretriable(e::APIsResult{BybitAPIError{110047}}) = false

# Risk limit cannot be adjusted as the current/expected position value exceeds the revised risk limit.
isretriable(e::APIsResult{BybitAPIError{110048}}) = false

# Tick notes can only be numbers
isretriable(e::APIsResult{BybitAPIError{110049}}) = false

# Invalid coin
isretriable(e::APIsResult{BybitAPIError{110050}}) = false

# The user's available balance cannot cover the lowest price of the current market
isretriable(e::APIsResult{BybitAPIError{110051}}) = false

# Your available balance is insufficient to set the price
isretriable(e::APIsResult{BybitAPIError{110052}}) = false

# The user's available balance cannot cover the current market price and upper limit price
isretriable(e::APIsResult{BybitAPIError{110053}}) = false

# This position has at least one take profit link order, so the take profit and stop loss mode cannot be switched
isretriable(e::APIsResult{BybitAPIError{110054}}) = false

# This position has at least one stop loss link order, so the take profit and stop loss mode cannot be switched
isretriable(e::APIsResult{BybitAPIError{110055}}) = false

# This position has at least one trailing stop link order, so the take profit and stop loss mode cannot be switched
isretriable(e::APIsResult{BybitAPIError{110056}}) = false

# Conditional order or limit order contains TP/SL related params
isretriable(e::APIsResult{BybitAPIError{110057}}) = false

# You can't set take profit and stop loss due to insufficient size of remaining position size.
isretriable(e::APIsResult{BybitAPIError{110058}}) = false

# Not allowed to modify the TP/SL of a partially filled open order
isretriable(e::APIsResult{BybitAPIError{110059}}) = false

# Under full TP/SL mode, it is not allowed to modify TP/SL
isretriable(e::APIsResult{BybitAPIError{110060}}) = false

# Not allowed to have more than 20 TP/SLs under Partial tpSlMode
isretriable(e::APIsResult{BybitAPIError{110061}}) = true

# There is no MMP information of the institution found.
isretriable(e::APIsResult{BybitAPIError{110062}}) = false

# Settlement in progress! {{key0}} not available for trading.
isretriable(e::APIsResult{BybitAPIError{110063}}) = false

# The modified contract quantity cannot be less than or equal to the filled quantity.
isretriable(e::APIsResult{BybitAPIError{110064}}) = false

# MMP hasn't yet been enabled for your account. Please contact your BD manager.
isretriable(e::APIsResult{BybitAPIError{110065}}) = false

# Trading is currently not allowed.
isretriable(e::APIsResult{BybitAPIError{110066}}) = false

# Unified account is not supported.
isretriable(e::APIsResult{BybitAPIError{110067}}) = false

# Leveraged trading is not allowed.
isretriable(e::APIsResult{BybitAPIError{110068}}) = false

# Ins lending customer is not allowed to trade.
isretriable(e::APIsResult{BybitAPIError{110069}}) = false

# ETP symbols cannot be traded.
isretriable(e::APIsResult{BybitAPIError{110070}}) = false

# Sorry, we're revamping the Unified Margin Account! Currently, new upgrades are not supported. If you have any questions, please contact our 24/7 customer support.
isretriable(e::APIsResult{BybitAPIError{110071}}) = false

# OrderLinkedID is duplicate
isretriable(e::APIsResult{BybitAPIError{110072}}) = false

# Set margin mode failed
isretriable(e::APIsResult{BybitAPIError{110073}}) = false

# RiskId not modified
isretriable(e::APIsResult{BybitAPIError{110075}}) = false

# Only isolated mode can set auto-add-margin
isretriable(e::APIsResult{BybitAPIError{110076}}) = false

# Pm mode cannot support
isretriable(e::APIsResult{BybitAPIError{110077}}) = false

# Added margin more than max can reduce margin
isretriable(e::APIsResult{BybitAPIError{110078}}) = false

# The order is processing and can not be operated, please try again later
isretriable(e::APIsResult{BybitAPIError{110079}}) = false

# Temporary banned due to the upgrade to UTA
isretriable(e::APIsResult{BybitAPIError{3100197}}) = false

# isolated margin can not create order
isretriable(e::APIsResult{BybitAPIError{3200403}}) = false

# You have unclosed hedge mode or isolated mode USDT perpetual positions
isretriable(e::APIsResult{BybitAPIError{3400208}}) = false

# You have USDT perpetual positions, so upgrading is prohibited for 10 minutes before and after the hour every hour
isretriable(e::APIsResult{BybitAPIError{3400209}}) = false

# The risk rate of your Derivatives account is too high
isretriable(e::APIsResult{BybitAPIError{3400210}}) = false

# Once upgraded, the estimated risk rate will be too high
isretriable(e::APIsResult{BybitAPIError{3400211}}) = false

# You have USDC perpetual positions or Options positions, so upgrading is prohibited for 10 minutes before and after the hour every hour
isretriable(e::APIsResult{BybitAPIError{3400212}}) = false

# The risk rate of your USDC Derivatives account is too high
isretriable(e::APIsResult{BybitAPIError{3400213}}) = false

# You have uncancelled USDC perpetual orders
isretriable(e::APIsResult{BybitAPIError{3400052}}) = false

# You have uncancelled Options orders
isretriable(e::APIsResult{BybitAPIError{3400053}}) = false

# You have uncancelled USDT perpetual orders
isretriable(e::APIsResult{BybitAPIError{3400054}}) = false

# Server error, please try again later
isretriable(e::APIsResult{BybitAPIError{3400214}}) = false

# The net asset is not satisfied
isretriable(e::APIsResult{BybitAPIError{3400071}}) = false
