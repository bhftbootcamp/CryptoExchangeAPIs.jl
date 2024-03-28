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

Binance.CoinMFutures.continuous_candle(;
    pair = "BTCUSD",
    contractType = Binance.CoinMFutures.ContinuousCandle.PERPETUAL,
    interval = Binance.CoinMFutures.ContinuousCandle.M1,
)

Binance.CoinMFutures.exchange_info()

Binance.CoinMFutures.funding_rate(; symbol = "BTCUSD_PERP")

binance_client = BinanceClient(;
    base_url = "https://dapi.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
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
