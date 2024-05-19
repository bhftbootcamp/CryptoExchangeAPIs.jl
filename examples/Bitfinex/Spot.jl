# Bitfinex/Spot
# https://docs.bitfinex.com/docs/rest-public

using Dates
using CryptoAPIs
using CryptoAPIs.Bitfinex


CryptoAPIs.Bitfinex.Spot.candle(;
    timeframe = CryptoAPIs.Bitfinex.Spot.Candle.m5,
    symbol = "tBTCUSD",
    start = now(UTC) - Minute(100),
    _end = now(UTC) - Minute(10),
)

CryptoAPIs.Bitfinex.Spot.order_book(;
    symbol = "tBTCUSD",
    precision = CryptoAPIs.Bitfinex.Spot.OrderBook.P1,
    len = CryptoAPIs.Bitfinex.Spot.OrderBook.TWENTY_FIVE,
)

CryptoAPIs.Bitfinex.Spot.ticker(; symbols = "tBTCUSD")

CryptoAPIs.Bitfinex.Spot.trades_pair(;
    symbol = "tBTCUSD",
    start = DateTime("2023-03-17T08:47:43.073"),
)
