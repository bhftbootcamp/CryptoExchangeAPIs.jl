# Coinbase/Spot
# https://docs.cloud.coinbase.com

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Coinbase

Coinbase.Spot.candle(;
    granularity = Coinbase.Spot.Candle.m1,
    product_id = "BTC-USD",
    start = DateTime("2023-02-02T15:33:20"),
    _end = DateTime("2023-02-02T15:33:20") + Hour(1),
)

Coinbase.Spot.currency()

Coinbase.Spot.product(; type = "BTC-USD")

Coinbase.Spot.product_stats(; product_id = "BTC-USD")

Coinbase.Spot.ticker(; product_id = "BTC-USDT")

coinbase_client = CoinbaseClient(;
    base_url = "https://api.exchange.coinbase.com",
    public_key = ENV["COINBASE_PUBLIC_KEY"],
    secret_key = ENV["COINBASE_SECRET_KEY"],
    passphrase = ENV["COINBASE_PASSPHRASE"],
)

Coinbase.Spot.fee_estimate(coinbase_client)
