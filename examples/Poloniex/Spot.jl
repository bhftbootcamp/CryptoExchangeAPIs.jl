# Poloniex/Spot
# https://docs.poloniex.com

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Poloniex

CryptoExchangeAPIs.Poloniex.Spot.candle(;
    symbol = "BTC_USDT",
    interval = CryptoExchangeAPIs.Poloniex.Spot.Candle.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)

CryptoExchangeAPIs.Poloniex.Spot.currency()

CryptoExchangeAPIs.Poloniex.Spot.market(; symbol = "BTC_USDT")

CryptoExchangeAPIs.Poloniex.Spot.order_book(;
    symbol = "BTC_USDT",
    limit = CryptoExchangeAPIs.Poloniex.Spot.OrderBook.FIVE,
)

CryptoExchangeAPIs.Poloniex.Spot.ticker(; symbol = "BTC_USDT")
