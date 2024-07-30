# ErrorHandling

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Binance

# NB: error_code number

CryptoExchangeAPIs.isretriable(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = true
CryptoExchangeAPIs.retry_maxcount(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = 2
CryptoExchangeAPIs.retry_timeout(::CryptoExchangeAPIs.APIsResult{BinanceAPIError{-1121}}) = 10

Binance.Spot.candle(;
    symbol = "ADADADA",
    interval = Binance.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

using CryptoExchangeAPIs.Coinbase

# NB: error_code symbol

CryptoExchangeAPIs.isretriable(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = true
CryptoExchangeAPIs.retry_maxcount(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 2
CryptoExchangeAPIs.retry_timeout(::CryptoExchangeAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 10

CryptoExchangeAPIs.Coinbase.Spot.candle(;
    granularity = Coinbase.Spot.Candle.m1,
    product_id = "ADA-ADA",
    start = DateTime("2023-02-02T15:33:20"),
    _end = DateTime("2023-02-02T15:33:20") + Hour(1),
)
