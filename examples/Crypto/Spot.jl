#Crypto/Spot
#https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#introduction

using Dates
using CryptoAPIs
using CryptoAPIs.Crypto

CryptoAPIs.Crypto.Spot.candle(;
    instrument_name = "BTC_USDT",
    timeframe = "M1",
) 

CryptoAPIs.Crypto.Spot.get_instruments()

CryptoAPIs.Crypto.Spot.ticker(; instrument_name = "BTCUSD-PERP") 