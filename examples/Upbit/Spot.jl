# Upbit/Spot
# https://docs.upbit.com

using Dates
using CryptoAPIs
using CryptoAPIs.Upbit

CryptoAPIs.Upbit.Spot.day_candle(;
    market = "KRW-BTC",
    convertingPriceUnit = "KRW",
    count = 1,
    to = DateTime("2023-01-01T00:00:00"),
)

CryptoAPIs.Upbit.Spot.market_list(; isDetails = true)

CryptoAPIs.Upbit.Spot.order_book(; markets = "KRW-BTC")

CryptoAPIs.Upbit.Spot.ticker(; markets = "KRW-BTC")
CryptoAPIs.Upbit.Spot.ticker(; markets = ["KRW-BTC", "BTC-ETH"])

upbit_client = UpbitClient(;
    base_url = "https://api.upbit.com",
    public_key = ENV["UPBIT_PUBLIC_KEY"],
    secret_key = ENV["UPBIT_SECRET_KEY"],
)

CryptoAPIs.Upbit.Spot.status_wallet(upbit_client)
