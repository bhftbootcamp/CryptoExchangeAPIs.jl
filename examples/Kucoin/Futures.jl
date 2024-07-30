# Kucoin/Futures
# https://docs.kucoin.com/

using NanoDates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kucoin

CryptoExchangeAPIs.Kucoin.Futures.candle(;
    symbol = ".KXBT",
    granularity = Kucoin.Futures.Candle.m1,
)

CryptoExchangeAPIs.Kucoin.Futures.contract()

CryptoExchangeAPIs.Kucoin.Futures.public_funding_history(; 
    symbol = "IDUSDTM",
    from = NanoDate("2023-11-18T12:31:40"),
    to = NanoDate("2023-12-11T16:05:00"),
)

kucoin_client = KucoinClient(;
    base_url = "https://api-futures.kucoin.com",
    public_key = ENV["KUCOIN_PUBLIC_KEY"],
    secret_key = ENV["KUCOIN_SECRET_KEY"],
    passphrase = ENV["KUCOIN_PASSPHRASE"],
)

CryptoExchangeAPIs.Kucoin.Futures.private_funding_history(
    kucoin_client;
    symbol = "XBTUSDM",
)
