# Okex/Spot
# https://www.okx.com/docs-v5/en/

using Dates
using CryptoAPIs
using CryptoAPIs.Okex

CryptoAPIs.Okex.Spot.candle(;
    instId = "BTC-USDT",
    bar = Okex.Spot.Candle.d1,
)

okex_client = OkexClient(;
    base_url = "https://www.okex.com",
    public_key = ENV["OKEX_PUBLIC_KEY"],
    secret_key = ENV["OKEX_SECRET_KEY"],
    passphrase = ENV["OKEX_PASSPHRASE"],
)

CryptoAPIs.Okex.Spot.currency(okex_client; ccy = "BTC")
