# Upbit/Spot
# https://docs.upbit.com

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Upbit

CryptoExchangeAPIs.Upbit.Spot.day_candle(;
    market = "KRW-BTC",
    convertingPriceUnit = "KRW",
    count = 1,
    to = DateTime("2023-01-01T00:00:00"),
)

CryptoExchangeAPIs.Upbit.Spot.market_list(; isDetails = true)

CryptoExchangeAPIs.Upbit.Spot.order_book(; markets = "KRW-BTC")

CryptoExchangeAPIs.Upbit.Spot.ticker(; markets = "KRW-BTC")
CryptoExchangeAPIs.Upbit.Spot.ticker(; markets = ["KRW-BTC", "BTC-ETH"])

upbit_client = UpbitClient(;
    base_url = "https://api.upbit.com",
    public_key = ENV["UPBIT_PUBLIC_KEY"],
    secret_key = ENV["UPBIT_SECRET_KEY"],
)

CryptoExchangeAPIs.Upbit.Spot.status_wallet(upbit_client)
