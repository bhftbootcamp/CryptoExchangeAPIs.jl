# Coinbase/Spot
# https://docs.cloud.coinbase.com

using Dates
using CryptoAPIs
using CryptoAPIs.Coinbase

CryptoAPIs.Coinbase.Spot.candle(;
    granularity = Coinbase.Spot.Candle.m1,
    product_id = "BTC-USD",
    start = DateTime("2023-02-02T15:33:20"),
    _end = DateTime("2023-02-02T15:33:20") + Hour(1),
)

CryptoAPIs.Coinbase.Spot.currency()

CryptoAPIs.Coinbase.Spot.fee_estimate()

CryptoAPIs.Coinbase.Spot.product_stats(; product_id = "BTC-USD")

CryptoAPIs.Coinbase.Spot.ticker(; product_id = "BTC-USDT")
