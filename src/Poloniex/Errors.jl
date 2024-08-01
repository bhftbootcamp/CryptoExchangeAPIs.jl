# Poloniex/Errors
# https://docs.poloniex.com/#error-codes

import ..CryptoExchangeAPIs: APIsResult, APIsUndefError
import ..CryptoExchangeAPIs: isretriable, retry_maxcount, retry_timeout

# UNDEF
isretriable(e::APIsResult{PoloniexAPIError}) = true

# Internal System Error
isretriable(e::APIsResult{PoloniexAPIError{500}}) = true

# Internal Request Timeout
isretriable(e::APIsResult{PoloniexAPIError{603}}) = true

# Invalid Parameter
isretriable(e::APIsResult{PoloniexAPIError{601}}) = false

# System Error
isretriable(e::APIsResult{PoloniexAPIError{415}}) = true

# Missing Required Parameters
isretriable(e::APIsResult{PoloniexAPIError{602}}) = false

# Invalid UserId
isretriable(e::APIsResult{PoloniexAPIError{21604}}) = false

# Account Not Found
isretriable(e::APIsResult{PoloniexAPIError{21600}}) = false

# Invalid Account Type
isretriable(e::APIsResult{PoloniexAPIError{21605}}) = false

# Invalid Currency
isretriable(e::APIsResult{PoloniexAPIError{21102}}) = false

# Invalid account
isretriable(e::APIsResult{PoloniexAPIError{21100}}) = false

# Missing UserId and/or AccountId
isretriable(e::APIsResult{PoloniexAPIError{21704}}) = false

# Error updating accounts
isretriable(e::APIsResult{PoloniexAPIError{21700}}) = false

# Invalid currency type
isretriable(e::APIsResult{PoloniexAPIError{21705}}) = false

# Internal accounts Error
isretriable(e::APIsResult{PoloniexAPIError{21707}}) = false

# Currency not available to User
isretriable(e::APIsResult{PoloniexAPIError{21708}}) = false

# Account locked. Contact support
isretriable(e::APIsResult{PoloniexAPIError{21601}}) = false

# Currency locked. Contact support
isretriable(e::APIsResult{PoloniexAPIError{21711}}) = false

# Insufficient balance
isretriable(e::APIsResult{PoloniexAPIError{21709}}) = false

# Transfer error. Try again later
isretriable(e::APIsResult{PoloniexAPIError{250000}}) = true

# Invalid toAccount for transfer
isretriable(e::APIsResult{PoloniexAPIError{250001}}) = false

# Invalid fromAccount for transfer
isretriable(e::APIsResult{PoloniexAPIError{250002}}) = false

# Invalid transfer amount
isretriable(e::APIsResult{PoloniexAPIError{250003}}) = false

# Transfer is not supported
isretriable(e::APIsResult{PoloniexAPIError{250004}}) = false

# Insufficient transfer balance
isretriable(e::APIsResult{PoloniexAPIError{250005}}) = false

# Invalid transfer currency
isretriable(e::APIsResult{PoloniexAPIError{250008}}) = false

# Futures account is not valid
isretriable(e::APIsResult{PoloniexAPIError{250012}}) = false

# Invalid quote currency
isretriable(e::APIsResult{PoloniexAPIError{21110}}) = false

# Invalid symbol
isretriable(e::APIsResult{PoloniexAPIError{10040}}) = false

# Symbol setup error
isretriable(e::APIsResult{PoloniexAPIError{10060}}) = false

# Invalid currency
isretriable(e::APIsResult{PoloniexAPIError{10020}}) = false

# Symbol frozen for trading
isretriable(e::APIsResult{PoloniexAPIError{10041}}) = false

# No order creation/cancelation is allowed as Poloniex is in Maintenane Mode
isretriable(e::APIsResult{PoloniexAPIError{21340}}) = false

# Post-only orders (type as LIMIT_MAKER) allowed as Poloniex is in Post Only Mode
isretriable(e::APIsResult{PoloniexAPIError{21341}}) = false

# Price is higher than highest bid as Poloniex is in Maintenance Mode
isretriable(e::APIsResult{PoloniexAPIError{21342}}) = false

# Price is lower than lowest bid as Poloniex is in Maintenance Mode
isretriable(e::APIsResult{PoloniexAPIError{21343}}) = false

# Trading for this account is frozen. Contact support
isretriable(e::APIsResult{PoloniexAPIError{21351}}) = false

# Trading for this currency is frozen
isretriable(e::APIsResult{PoloniexAPIError{21352}}) = false

# Trading for US customers is not supported
isretriable(e::APIsResult{PoloniexAPIError{21353}}) = false

# Account needs to be verified via email before trading is enabled. Contact support
isretriable(e::APIsResult{PoloniexAPIError{21354}}) = false

# Invalid market depth
isretriable(e::APIsResult{PoloniexAPIError{24106}}) = false

# Service busy. Try again later
isretriable(e::APIsResult{PoloniexAPIError{24201}}) = true
retry_timeout(e::APIsResult{PoloniexAPIError{24201}}) = 2
retry_maxcount(e::APIsResult{PoloniexAPIError{24201}}) = 50

# Order not found
isretriable(e::APIsResult{PoloniexAPIError{21301}}) = false

# Batch cancel order error
isretriable(e::APIsResult{PoloniexAPIError{21302}}) = false

# Order is filled
isretriable(e::APIsResult{PoloniexAPIError{21304}}) = false

# Order is canceled
isretriable(e::APIsResult{PoloniexAPIError{21305}}) = false

# Error during Order Cancelation
isretriable(e::APIsResult{PoloniexAPIError{21307}}) = false

# Order price must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21309}}) = false

# Order price must be less than max price
isretriable(e::APIsResult{PoloniexAPIError{21310}}) = false

# Order price must be greater than min price
isretriable(e::APIsResult{PoloniexAPIError{21311}}) = false

# PoloniexClient orderId already exists
isretriable(e::APIsResult{PoloniexAPIError{21312}}) = false

# Max limit of open orders (2000) exceeded
isretriable(e::APIsResult{PoloniexAPIError{21314}}) = false

# PoloniexClient orderId exceeded max length of 17 digits
isretriable(e::APIsResult{PoloniexAPIError{21315}}) = false

# Amount must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21317}}) = false

# Invalid order side
isretriable(e::APIsResult{PoloniexAPIError{21319}}) = false

# Invalid order type
isretriable(e::APIsResult{PoloniexAPIError{21320}}) = false

# Invalid timeInForce value
isretriable(e::APIsResult{PoloniexAPIError{21321}}) = false

# Amount is less than minAmount trade limit
isretriable(e::APIsResult{PoloniexAPIError{21322}}) = false

# Invalid account type
isretriable(e::APIsResult{PoloniexAPIError{21324}}) = false

# Order pice must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21327}}) = false

# Order quantity must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21328}}) = false

# Quantity is less than minQuantity trade limit
isretriable(e::APIsResult{PoloniexAPIError{21330}}) = false

# Invalid priceScale for this symbol
isretriable(e::APIsResult{PoloniexAPIError{21335}}) = false

# Invalid quantityScale for this symbol
isretriable(e::APIsResult{PoloniexAPIError{21336}}) = false

# Invalid amountScale for this symbol
isretriable(e::APIsResult{PoloniexAPIError{21337}}) = false

# Value of limit param is greater than max value of 100
isretriable(e::APIsResult{PoloniexAPIError{21344}}) = false

# Value of limit param value must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21345}}) = false

# Order Id must be of type Long
isretriable(e::APIsResult{PoloniexAPIError{21346}}) = false

# Order type must be LIMIT_MAKER
isretriable(e::APIsResult{PoloniexAPIError{21348}}) = false

# Stop price must be greater than 0
isretriable(e::APIsResult{PoloniexAPIError{21347}}) = false

# Order value is too large
isretriable(e::APIsResult{PoloniexAPIError{21349}}) = false

# Amount must be greater than 1 USDT
isretriable(e::APIsResult{PoloniexAPIError{21350}}) = false

# Interval between startTime and endTime in trade/order history has exceeded 7 day limit
isretriable(e::APIsResult{PoloniexAPIError{21355}}) = false

# Order size would cause too much price movement. Reduce order size.
isretriable(e::APIsResult{PoloniexAPIError{21356}}) = false

# Invalid symbol
isretriable(e::APIsResult{PoloniexAPIError{24101}}) = false

# Invalid K-line type
isretriable(e::APIsResult{PoloniexAPIError{24102}}) = false

# Invalid endTime
isretriable(e::APIsResult{PoloniexAPIError{24103}}) = false

# Invalid amount
isretriable(e::APIsResult{PoloniexAPIError{24104}}) = false

# Invalid startTime
isretriable(e::APIsResult{PoloniexAPIError{24105}}) = false

# No active kill switch
isretriable(e::APIsResult{PoloniexAPIError{25020}}) = false

# Invalid userId
isretriable(e::APIsResult{PoloniexAPIError{25000}}) = false

# Invalid parameter
isretriable(e::APIsResult{PoloniexAPIError{25001}}) = false

# Invalid userId.
isretriable(e::APIsResult{PoloniexAPIError{25002}}) = false

# Unable to place order
isretriable(e::APIsResult{PoloniexAPIError{25003}}) = false

# PoloniexClient orderId already exists
isretriable(e::APIsResult{PoloniexAPIError{25004}}) = false

# Unable to place smart order
isretriable(e::APIsResult{PoloniexAPIError{25005}}) = false

# OrderId and clientOrderId already exists
isretriable(e::APIsResult{PoloniexAPIError{25006}}) = false

# Invalid orderid
isretriable(e::APIsResult{PoloniexAPIError{25007}}) = false

# Both orderId and clientOrderId are required
isretriable(e::APIsResult{PoloniexAPIError{25008}}) = false

# Failed to cancel order
isretriable(e::APIsResult{PoloniexAPIError{25009}}) = false

# Unauthorized to cancel order
isretriable(e::APIsResult{PoloniexAPIError{25010}}) = false

# Failed to cancel due to invalid paramters
isretriable(e::APIsResult{PoloniexAPIError{25011}}) = false

# Failed to cancel
isretriable(e::APIsResult{PoloniexAPIError{25012}}) = false

# Failed to cancel as orders were not found
isretriable(e::APIsResult{PoloniexAPIError{25013}}) = false

# Failed to cancel as smartorders were not found
isretriable(e::APIsResult{PoloniexAPIError{25014}}) = false

# Failed to cancel as no orders exist
isretriable(e::APIsResult{PoloniexAPIError{25015}}) = false

# Failed to cancel as unable to release funds
isretriable(e::APIsResult{PoloniexAPIError{25016}}) = false

# No orders were canceled
isretriable(e::APIsResult{PoloniexAPIError{25017}}) = false

# Invalid accountType
isretriable(e::APIsResult{PoloniexAPIError{25018}}) = false

# Invalid symbol
isretriable(e::APIsResult{PoloniexAPIError{25019}}) = false
