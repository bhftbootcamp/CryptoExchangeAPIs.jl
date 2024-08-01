# Gateio/Futures
# https://www.gate.io/docs/developers/apiv4

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Gateio

Gateio.Futures.candle(;
    type = Gateio.Futures.Candle.mark,
    name = "BTC_USDT",
    settle = Gateio.Futures.Candle.usdt,
    from = DateTime("2024-04-01T10:00:00"),
    to = DateTime("2024-04-01T10:00:00") + Hour(1),
    interval = Gateio.Futures.Candle.m1,
)

Gateio.Futures.contract(;
    settle = Gateio.Futures.Contract.btc,
    limit = 5,
)

Gateio.Futures.funding_rate(;
    settle = Gateio.Futures.FundingRate.usdt,
    contract = "BTC_USDT",
    limit = 5,
)

Gateio.Futures.order_book(;
    settle = Gateio.Futures.OrderBook.usdt,
    contract = "BTC_USDT",
    interval = "5",
    with_id = true
)

Gateio.Futures.ticker(; settle = Gateio.Futures.Ticker.btc)
