# Bybit/Spot
# https://bybit-exchange.github.io/docs/

using Dates
using CryptoAPIs
using CryptoAPIs.Bybit

CryptoAPIs.Bybit.Spot.candle(;
    symbol = "ADAUSDT",
    interval = CryptoAPIs.Bybit.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

CryptoAPIs.Bybit.Spot.symbol_info()

CryptoAPIs.Bybit.Spot.order_book(; symbol = "ADAUSDT")

CryptoAPIs.Bybit.Spot.ticker(; symbol = "ADAUSDT")

bybit_client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

CryptoAPIs.Bybit.Spot.deposit(bybit_client)

CryptoAPIs.Bybit.Spot.coin_info(bybit_client)
