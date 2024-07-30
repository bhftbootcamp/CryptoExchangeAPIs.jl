# Bithumb/Spot
# https://apidocs.bithumb.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bithumb

CryptoExchangeAPIs.Bithumb.Spot.asset_status()
CryptoExchangeAPIs.Bithumb.Spot.asset_status(; currency = "ADA")

CryptoExchangeAPIs.Bithumb.Spot.candle(;
    order_currency = "BTC",
    payment_currency = "KRW",
    interval = CryptoExchangeAPIs.Bithumb.Spot.Candle.h24,
)

CryptoExchangeAPIs.Bithumb.Spot.order_book(;
    order_currency = "BTC",
    payment_currency = "KRW",
    count = 5,
)
CryptoExchangeAPIs.Bithumb.Spot.order_book(;
    payment_currency = "KRW",
    count = 5,
)

CryptoExchangeAPIs.Bithumb.Spot.ticker(;
    order_currency = "BTC",
    payment_currency = "KRW",
)

CryptoExchangeAPIs.Bithumb.Spot.ticker(;
    payment_currency = "KRW",
)

bithumb_client = CryptoExchangeAPIs.Bithumb.BithumbClient(;
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
