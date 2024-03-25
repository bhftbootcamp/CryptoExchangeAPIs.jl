# Binance/USDMFutures
# https://binance-docs.github.io/apidocs/futures/en

using Dates
using CryptoAPIs
using CryptoAPIs.Binance

Binance.USDMFutures.candle(;
    symbol = "BTCUSDT",
    interval = Binance.USDMFutures.Candle.m5,
)

Binance.USDMFutures.candle(;
    symbol = "BTCUSDT",
    interval = Binance.USDMFutures.Candle.m5,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 5,
)

Binance.USDMFutures.exchange_info()

Binance.USDMFutures.funding_rate_log(; symbol = "BTCUSDT")

Binance.USDMFutures.order_book(; symbol = "BTCUSDT")
Binance.USDMFutures.order_book(; symbol = "BTCUSDT", limit = 10)

Binance.USDMFutures.ticker(; symbol = "BTCUSDT")
