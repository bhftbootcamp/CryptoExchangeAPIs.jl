# Gateio/Futures
# https://www.gate.io/docs/developers/apiv4

using Dates
using CryptoAPIs
using CryptoAPIs.Gateio

CryptoAPIs.Gateio.Futures.candle(; 
    type = Gateio.Futures.Candle.mark,
    instrument_name = "BTC_USDT",
    settle = "usdt",
    interval = Gateio.Futures.Candle.d30,
)

CryptoAPIs.Gateio.Futures.contract(; settle = "btc")

CryptoAPIs.Gateio.Futures.funding_rate(; 
    settle = "usdt",
    contract = "BTC_USDT",
)

CryptoAPIs.Gateio.Futures.order_book(; 
    settle = "usdt",
    contract = "BTC_USDT",
)

CryptoAPIs.Gateio.Futures.ticker(; settle = "btc")
