# Bybit/Spot
# https://bybit-exchange.github.io/docs/

using Dates
using CryptoAPIs
using CryptoAPIs.Bybit

Bybit.Spot.candle(;
    symbol = "ADAUSDT",
    interval = Bybit.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

Bybit.Spot.symbols_info()
