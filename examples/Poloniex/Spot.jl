# Poloniex/Spot
# https://docs.poloniex.com

using Dates
using CryptoAPIs
using CryptoAPIs.Poloniex

CryptoAPIs.Poloniex.Spot.candle(;
    symbol = "BTC_USDT",
    interval = CryptoAPIs.Poloniex.Spot.Candle.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)

CryptoAPIs.Poloniex.Spot.currency()

CryptoAPIs.Poloniex.Spot.market(; symbol = "BTC_USDT")

CryptoAPIs.Poloniex.Spot.order_book(;
    symbol = "BTC_USDT",
    limit = CryptoAPIs.Poloniex.Spot.OrderBook.FIVE,
)

CryptoAPIs.Poloniex.Spot.ticker(; symbol = "BTC_USDT")
