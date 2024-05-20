# Huobi/Spot
# https://huobiapi.github.io/docs/spot/v1/en

using Dates
using CryptoAPIs
using CryptoAPIs.Huobi

CryptoAPIs.Huobi.Spot.candle(; symbol = "btcusdt", period = CryptoAPIs.Huobi.Spot.Candle.m1)

CryptoAPIs.Huobi.Spot.common_symbol()

CryptoAPIs.Huobi.Spot.order_book(; symbol = "btcusdt")

CryptoAPIs.Huobi.Spot.ticker()

huobi_client = CryptoAPIs.Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

CryptoAPIs.Huobi.Spot.currency(huobi_client; currency = "btc", authorizedUser = true)

CryptoAPIs.Huobi.Spot.deposit_withdrawal(
    huobi_client;
    currency = "btc",
    direct = CryptoAPIs.Huobi.Spot.DepositWithdrawal.prev,
    from = "1",
    size = 500,
    type = "deposit",
)

CryptoAPIs.Huobi.Spot.order_log(
    huobi_client;
    start_time = now(UTC) - Day(1),
    end_time = now(UTC) - Hour(1),
    size = 1000,
)
