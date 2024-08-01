# Binance/USDMFutures
# https://binance-docs.github.io/apidocs/futures/en

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Binance

Binance.USDMFutures.candle(;
    symbol = "BTCUSDT",
    interval = Binance.USDMFutures.Candle.m5,
)

Binance.USDMFutures.candle(;
    symbol = "BTCUSDT",
    interval = Binance.USDMFutures.Candle.m5,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 5,
)

Binance.USDMFutures.continuous_candle(;
    pair = "BTCUSDT",
    contractType = Binance.USDMFutures.ContinuousCandle.PERPETUAL,
    interval = Binance.USDMFutures.ContinuousCandle.M1,
)

Binance.USDMFutures.exchange_info()

Binance.USDMFutures.funding_rate(; symbol = "BTCUSDT")

Binance.USDMFutures.historical_trades(; symbol = "BTCUSDT")

Binance.USDMFutures.long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.LongShortRatio.h1,
)

Binance.USDMFutures.open_interest_hist(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.OpenInterestHist.h1,
)

Binance.USDMFutures.order_book(; symbol = "BTCUSDT")
Binance.USDMFutures.order_book(; symbol = "BTCUSDT", limit = 10)

Binance.USDMFutures.premium_index(; symbol = "BTCUSDT")

Binance.USDMFutures.taker_long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TakerLongShortRatio.h1,
)

Binance.USDMFutures.ticker(; symbol = "BTCUSDT")

Binance.USDMFutures.top_long_short_account_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TopLongShortAccountRatio.h1,
)

Binance.USDMFutures.top_long_short_position_ratio(;
    symbol = "BTCUSDT",
    period = Binance.USDMFutures.TopLongShortPositionRatio.h1,
)
