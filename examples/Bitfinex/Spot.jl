# Bitfinex/Spot
# https://docs.bitfinex.com/docs/rest-public

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bitfinex

Bitfinex.Spot.candle(;
    timeframe = CryptoExchangeAPIs.Bitfinex.Spot.Candle.m5,
    symbol = "tBTCUSD",
    start = now(UTC) - Minute(100),
    _end = now(UTC) - Minute(10),
)

Bitfinex.Spot.order_book(;
    symbol = "tBTCUSD",
    precision = CryptoExchangeAPIs.Bitfinex.Spot.OrderBook.P1,
    len = CryptoExchangeAPIs.Bitfinex.Spot.OrderBook.TWENTY_FIVE,
)

Bitfinex.Spot.ticker(; symbols = "tBTCUSD")

Bitfinex.Spot.trade_pair(;
    symbol = "tBTCUSD",
    start = DateTime("2023-03-17T08:47:43.073"),
)
