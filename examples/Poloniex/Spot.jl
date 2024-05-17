# Poloniex/Spot
# https://docs.poloniex.com

using Dates
using CryptoAPIs
using CryptoAPIs.Poloniex

CryptoAPIs.Poloniex.Spot.candle(;
    symbol = "BTC_USDT",
    interval = CryptoAPIs.Poloniex.Spot.Candle.m5,
    startTime = now(UTC) - Minute(100),
    endTime = now(UTC) - Hour(1),
)

CryptoAPIs.Poloniex.Spot.currency()

CryptoAPIs.Poloniex.Spot.currency_v2()

CryptoAPIs.Poloniex.Spot.market(; symbol = "BTC_USDT")

CryptoAPIs.Poloniex.Spot.order_book(;
    symbol = "BTC_USDT",
    limit = CryptoAPIs.Poloniex.Spot.OrderBook.FIVE,
)

CryptoAPIs.Poloniex.Spot.ticker(; symbol = "BTC_USDT")

poloniex_client = CryptoAPIs.Poloniex.PoloniexClient(;
    base_url = "https://api.poloniex.com",
    public_key = ENV["POLONIEX_PUBLIC_KEY"],
    secret_key = ENV["POLONIEX_SECRET_KEY"],
)

CryptoAPIs.Poloniex.Spot.deposit_withdrawal(
    poloniex_client;
    start = Dates.DateTime("2022-04-03T15:33:20"),
    _end = Dates.DateTime("2022-07-28T09:20:00"),
)
