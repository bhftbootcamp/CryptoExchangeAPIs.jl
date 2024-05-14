# Kucoin/Spot
# https://docs.kucoin.com/

using Dates
using CryptoAPIs
using CryptoAPIs.Kucoin

CryptoAPIs.Kucoin.Spot.candle(;
    symbol = "BTC-USDT",
    type = CryptoAPIs.Kucoin.Spot.Candle.m1,
)

kucoin_client = KucoinClient(;
    base_url = "https://api.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

CryptoAPIs.Kucoin.Spot.deposit(
    kucoin_client;
    currency = "BTC",
)
