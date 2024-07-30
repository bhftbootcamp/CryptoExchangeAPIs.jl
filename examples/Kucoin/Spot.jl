# Kucoin/Spot
# https://docs.kucoin.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kucoin

CryptoExchangeAPIs.Kucoin.Spot.candle(;
    symbol = "BTC-USDT",
    type = CryptoExchangeAPIs.Kucoin.Spot.Candle.m1,
)

kucoin_client = KucoinClient(;
    base_url = "https://api.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

CryptoExchangeAPIs.Kucoin.Spot.deposit(
    kucoin_client;
    currency = "BTC",
)
