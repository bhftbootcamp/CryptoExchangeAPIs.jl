# Huobi/Spot
# https://huobiapi.github.io/docs/spot/v1/en

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Huobi

CryptoExchangeAPIs.Huobi.Spot.candle(; symbol = "btcusdt", period = CryptoExchangeAPIs.Huobi.Spot.Candle.m1)

CryptoExchangeAPIs.Huobi.Spot.order_book(; symbol = "btcusdt")

CryptoExchangeAPIs.Huobi.Spot.ticker()

huobi_client = CryptoExchangeAPIs.Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

CryptoExchangeAPIs.Huobi.Spot.currency(huobi_client; currency = "btc", authorizedUser = true)

CryptoExchangeAPIs.Huobi.Spot.deposit_withdrawal(
    huobi_client;
    currency = "btc",
    direct = CryptoExchangeAPIs.Huobi.Spot.DepositWithdrawal.prev,
    from = "1",
    size = 500,
    type = "deposit",
)

CryptoExchangeAPIs.Huobi.Spot.order_log(
    huobi_client;
    start_time = now(UTC) - Day(1),
    end_time = now(UTC) - Hour(1),
    size = 1000,
)
