# Cryptocom/Spot
# https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#introduction

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Cryptocom

Cryptocom.Spot.candle(;
    instrument_name = "BTC_USDT",
    timeframe = Cryptocom.Spot.Candle.M1,
    start_ts = Dates.now() - Dates.Day(1),
    end_ts = Dates.now(),
)

Cryptocom.Spot.get_instruments()

Cryptocom.Spot.ticker(; instrument_name = "BTCUSD-PERP")
