# Poloniex/Spot
# https://docs.poloniex.com

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Poloniex

Poloniex.Spot.candle(;
    symbol = "BTC_USDT",
    interval = Poloniex.Spot.Candle.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)

Poloniex.Spot.currency()

Poloniex.Spot.market(; symbol = "BTC_USDT")

Poloniex.Spot.order_book(;
    symbol = "BTC_USDT",
    limit = Poloniex.Spot.OrderBook.FIVE,
)

Poloniex.Spot.ticker(; symbol = "BTC_USDT")
