# ErrorHandling

using Dates
using CryptoAPIs
using CryptoAPIs.Binance

# NB: error_code number

CryptoAPIs.isretriable(::CryptoAPIs.APIsResult{BinanceAPIError{-1121}}) = true
CryptoAPIs.retry_maxcount(::CryptoAPIs.APIsResult{BinanceAPIError{-1121}}) = 2
CryptoAPIs.retry_timeout(::CryptoAPIs.APIsResult{BinanceAPIError{-1121}}) = 10

Binance.Spot.candle(;
    symbol = "ADADADA",
    interval = Binance.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

using CryptoAPIs.Coinbase

# NB: error_code symbol

CryptoAPIs.isretriable(::CryptoAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = true
CryptoAPIs.retry_maxcount(::CryptoAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 2
CryptoAPIs.retry_timeout(::CryptoAPIs.APIsResult{CoinbaseAPIError{Symbol("NotFound")}}) = 10

CryptoAPIs.Coinbase.Spot.candle(;
    granularity = Coinbase.Spot.Candle.m1,
    product_id = "ADA-ADA",
    start = DateTime("2023-02-02T15:33:20"),
    _end = DateTime("2023-02-02T15:33:20") + Hour(1),
)
