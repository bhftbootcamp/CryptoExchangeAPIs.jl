# Bithumb/Spot
# https://apidocs.bithumb.com/

using Dates
using CryptoAPIs
using CryptoAPIs.Bithumb

CryptoAPIs.Bithumb.Spot.asset_status()
CryptoAPIs.Bithumb.Spot.asset_status(; currency = "ADA")

CryptoAPIs.Bithumb.Spot.candle(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = CryptoAPIs.Bithumb.Spot.Candle.h24,
)

CryptoAPIs.Bithumb.Spot.order_book(;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 5,
)
CryptoAPIs.Bithumb.Spot.order_book(;
    payment_currency = "KRW",
    count = 5,
)

CryptoAPIs.Bithumb.Spot.ticker(;
    order_currency = "BTC",
    payment_currency = "KRW",
)

CryptoAPIs.Bithumb.Spot.ticker(;
    payment_currency = "KRW",
)

bithumb_client = CryptoAPIs.Bithumb.BithumbClient(;
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
