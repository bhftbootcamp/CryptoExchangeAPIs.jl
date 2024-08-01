# Bithumb/Spot
# https://apidocs.bithumb.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bithumb

Bithumb.Spot.asset_status()
Bithumb.Spot.asset_status(; currency = "ADA")

Bithumb.Spot.candle(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = Bithumb.Spot.Candle.h24,
)

Bithumb.Spot.order_book(;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 5,
)
Bithumb.Spot.order_book(;
    payment_currency = "KRW",
    count = 5,
)

Bithumb.Spot.ticker(;
    order_currency = "BTC",
    payment_currency = "KRW",
)

Bithumb.Spot.ticker(;
    payment_currency = "KRW",
)

bithumb_client = Bithumb.BithumbClient(;
    base_url = "https://api.bithumb.com",
    public_key = ENV["BITHUMB_PUBLIC_KEY"],
    secret_key = ENV["BITHUMB_SECRET_KEY"],
)

Bithumb.Spot.user_transactions_log(
    bithumb_client;
    order_currency = "ETH",
    payment_currency = "BTC",
    count = 50,
    searchGb = Bithumb.Spot.UserTransactionsLog.ALL,
)
