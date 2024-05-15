# Kraken/Spot
# https://docs.kraken.com/rest

using Dates
using CryptoAPIs
using CryptoAPIs.Kraken

CryptoAPIs.Kraken.Spot.asset(; asset = ["ADA", "SUSHI"])

CryptoAPIs.Kraken.Spot.asset_pair(; pair = "ACAUSD")
CryptoAPIs.Kraken.Spot.asset_pair(; info = CryptoAPIs.Kraken.Spot.AssetPair.fees)

CryptoAPIs.Kraken.Spot.candle(;
    pair = "ACAUSD",
    interval = CryptoAPIs.Kraken.Spot.Candle.h1,
    since = now(UTC) - Hour(1),
)

CryptoAPIs.Kraken.Spot.order_book(; pair = "XBTUSD", count = 10)

CryptoAPIs.Kraken.Spot.ticker()
CryptoAPIs.Kraken.Spot.ticker(; pair = "XBTUSD")

kraken_client = CryptoAPIs.Kraken.KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

CryptoAPIs.Kraken.Spot.deposit_log(kraken_client; asset = "XBT")

CryptoAPIs.Kraken.Spot.deposit_method(
    kraken_client;
    asset = "XBT",
)

CryptoAPIs.Kraken.Spot.ledger_info_log(
    kraken_client;
    type = CryptoAPIs.Kraken.Spot.LedgerInfoLog.margin,
    asset = "XBT",
    start = Dates.DateTime("2021-04-03T15:33:20"),
    _end = Dates.DateTime("2022-04-03T15:33:20"),
)

CryptoAPIs.Kraken.Spot.withdrawal_log(kraken_client; asset = "XBT")

CryptoAPIs.Kraken.Spot.withdrawal_method(kraken_client; asset = "XBT")
