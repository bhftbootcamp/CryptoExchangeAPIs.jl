# Cryptocom/Spot
# https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#introduction

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Cryptocom

CryptoExchangeAPIs.Cryptocom.Spot.candle(;
    instrument_name = "BTC_USDT",
    timeframe = Cryptocom.Spot.Candle.M1,
    start_ts = Dates.now() - Dates.Day(1),
    end_ts = Dates.now(),
)

CryptoExchangeAPIs.Cryptocom.Spot.get_instruments()

CryptoExchangeAPIs.Cryptocom.Spot.ticker(; instrument_name = "BTCUSD-PERP") 
