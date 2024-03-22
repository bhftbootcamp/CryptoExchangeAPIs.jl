# Binance/CoinMFutures
# https://binance-docs.github.io/apidocs/delivery/en

using Dates
using CryptoAPIs
using CryptoAPIs.Binance

Binance.CoinMFutures.candle(;
    symbol = "BTCUSD_PERP",
    interval = Binance.CoinMFutures.Candle.m5,
)

Binance.CoinMFutures.candle(;
    symbol = "BTCUSD_PERP",
    interval = Binance.CoinMFutures.Candle.m5,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 5,
)

Binance.CoinMFutures.exchange_info()

Binance.CoinMFutures.order_book(; symbol = "BTCUSD_PERP")
Binance.CoinMFutures.order_book(; symbol = "BTCUSD_PERP", limit = 10)

binance_client = BinanceClient(;
    base_url = "https://dapi.binance.com",
    public_key = ENV["BINANCE_FUT_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_FUT_SECRET_KEY"],
)

Binance.CoinMFutures.income_log(binance_client)

Binance.CoinMFutures.income_log(
    binance_client;
    symbol = "BTCUSD_PERP",
    incomeType = "COMMISSION",
    startTime = DateTime("2023-06-22"),
    endTime = DateTime("2023-07-23"),
    limit = 1000,
)
