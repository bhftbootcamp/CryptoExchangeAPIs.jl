# Aevo Examples
# https://api-docs.aevo.xyz/reference/overview

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Aevo

Aevo.assets()

Aevo.funding_history(; instrument_name = "ETH-PERP")

Aevo.funding_history(;
    instrument_name = "ETH-PERP",
    end_time = now(UTC),
    limit = 50
)

Aevo.statistics(;
    asset = "ETH",
    instrument_type = Aevo.Statistics.InstrumentType.PERPETUAL
)

Aevo.statistics(;
    asset = "BTC",
    instrument_type = Aevo.Statistics.InstrumentType.PERPETUAL,
    end_time = now(UTC)
)
