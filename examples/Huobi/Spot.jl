# Huobi/Spot
# https://huobiapi.github.io/docs/spot/v1/en

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Huobi

Huobi.Spot.candle(; symbol = "btcusdt", period = Huobi.Spot.Candle.m1)

Huobi.Spot.order_book(; symbol = "btcusdt")

Huobi.Spot.ticker()

huobi_client = Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

Huobi.Spot.currency(huobi_client; currency = "btc", authorizedUser = true)

Huobi.Spot.deposit_withdrawal(
    huobi_client;
    currency = "btc",
    direct = Huobi.Spot.DepositWithdrawal.prev,
    from = "1",
    size = 500,
    type = "deposit",
)

Huobi.Spot.order_log(
    huobi_client;
    start_time = now(UTC) - Day(1),
    end_time = now(UTC) - Hour(1),
    size = 1000,
)
