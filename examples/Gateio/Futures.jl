# Gateio/Futures
# https://www.gate.io/docs/developers/apiv4

using Dates
using CryptoAPIs
using CryptoAPIs.Gateio

CryptoAPIs.Gateio.Futures.candle(; 
    type = Gateio.Futures.Candle.mark,
    name = "BTC_USDT",
    settle = Gateio.Futures.Candle.usdt,
    from = DateTime("2024-04-01T10:00:00"),
    to = DateTime("2024-04-01T10:00:00") + Hour(1),
    interval = Gateio.Futures.Candle.m1,
)

CryptoAPIs.Gateio.Futures.contract(; 
    settle = Gateio.Futures.Contract.btc,
    limit = 5,
)

CryptoAPIs.Gateio.Futures.funding_rate(; 
    settle = Gateio.Futures.FundingRate.usdt,
    contract = "BTC_USDT",
    limit = 5,
)

CryptoAPIs.Gateio.Futures.order_book(; 
    settle = Gateio.Futures.OrderBook.usdt,
    contract = "BTC_USDT",
    interval = "5",
    with_id = true
)

CryptoAPIs.Gateio.Futures.ticker(; settle = Gateio.Futures.Ticker.btc)
