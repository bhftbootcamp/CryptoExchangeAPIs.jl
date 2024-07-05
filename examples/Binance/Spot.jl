# Binance/Spot
# https://binance-docs.github.io/apidocs/spot/en

using Dates
using CryptoAPIs
using CryptoAPIs.Binance

Binance.Spot.avg_price(; symbol = "ADAUSDT")

Binance.Spot.candle(;
    symbol = "ADAUSDT",
    interval = Binance.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

Binance.Spot.exchange_info()

Binance.Spot.order_book(; symbol = "BTCUSDT", limit = 10)

Binance.Spot.ticker()
Binance.Spot.ticker(; symbol = "BTCUSDT")
Binance.Spot.ticker(; symbols = ["BTCUSDT", "ADAUSDT"])

binance_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

Binance.Spot.account_trade(
    binance_client;
    symbol = "BTCUSDT",
)

Binance.Spot.coin_information(binance_client)

Binance.Spot.deposit_log(binance_client)

Binance.Spot.withdrawal_log(binance_client)

Binance.Spot.server_time()
