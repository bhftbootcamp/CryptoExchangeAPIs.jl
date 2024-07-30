# Kraken/Spot
# https://docs.kraken.com/rest

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kraken

CryptoExchangeAPIs.Kraken.Spot.asset(; asset = ["ADA", "SUSHI"])

CryptoExchangeAPIs.Kraken.Spot.asset_pair(; pair = "ACAUSD")
CryptoExchangeAPIs.Kraken.Spot.asset_pair(; info = CryptoExchangeAPIs.Kraken.Spot.AssetPair.fees)

CryptoExchangeAPIs.Kraken.Spot.candle(;
    pair = "ACAUSD",
    interval = CryptoExchangeAPIs.Kraken.Spot.Candle.h1,
    since = now(UTC) - Hour(1),
)

CryptoExchangeAPIs.Kraken.Spot.order_book(; pair = "XBTUSD", count = 10)

CryptoExchangeAPIs.Kraken.Spot.ticker()
CryptoExchangeAPIs.Kraken.Spot.ticker(; pair = "XBTUSD")

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

CryptoExchangeAPIs.Kraken.Spot.deposit_log(kraken_client; asset = "XBT")

CryptoExchangeAPIs.Kraken.Spot.deposit_method(
    kraken_client;
    asset = "XBT",
)

CryptoExchangeAPIs.Kraken.Spot.ledger_info_log(
    kraken_client;
    type = CryptoExchangeAPIs.Kraken.Spot.LedgerInfoLog.margin,
    asset = "XBT",
    start = Dates.DateTime("2021-04-03T15:33:20"),
    _end = Dates.DateTime("2022-04-03T15:33:20"),
)

CryptoExchangeAPIs.Kraken.Spot.withdrawal_log(kraken_client; asset = "XBT")

CryptoExchangeAPIs.Kraken.Spot.withdrawal_method(kraken_client; asset = "XBT")
