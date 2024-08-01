# Kraken/Spot
# https://docs.kraken.com/rest

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Kraken

Kraken.Spot.asset(; asset = ["ADA", "SUSHI"])

Kraken.Spot.asset_pair(; pair = "ACAUSD")
Kraken.Spot.asset_pair(; info = Kraken.Spot.AssetPair.fees)

Kraken.Spot.candle(;
    pair = "ACAUSD",
    interval = Kraken.Spot.Candle.h1,
    since = now(UTC) - Hour(1),
)

Kraken.Spot.order_book(; pair = "XBTUSD", count = 10)

Kraken.Spot.ticker()
Kraken.Spot.ticker(; pair = "XBTUSD")

kraken_client = KrakenClient(;
    base_url = "https://api.kraken.com",
    public_key = ENV["KRAKEN_PUBLIC_KEY"],
    secret_key = ENV["KRAKEN_SECRET_KEY"],
)

Kraken.Spot.deposit_log(kraken_client; asset = "XBT")

Kraken.Spot.deposit_method(
    kraken_client;
    asset = "XBT",
)

Kraken.Spot.ledger_info_log(
    kraken_client;
    type = Kraken.Spot.LedgerInfoLog.margin,
    asset = "XBT",
    start = Dates.DateTime("2021-04-03T15:33:20"),
    _end = Dates.DateTime("2022-04-03T15:33:20"),
)

Kraken.Spot.withdrawal_log(kraken_client; asset = "XBT")

Kraken.Spot.withdrawal_method(kraken_client; asset = "XBT")
