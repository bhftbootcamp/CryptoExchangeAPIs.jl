# Deribit/Common
# https://docs.deribit.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Deribit

# Common

Deribit.Common.candle(
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Minute(100),
    end_timestamp = now(UTC) - Hour(1),
    resolution = Deribit.Common.Candle.m1,
)

Deribit.Common.funding_rate(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = Dates.DateTime("2022-11-08"),
    end_timestamp = Dates.DateTime("2022-11-08") + Day(2),
)

Deribit.Common.order_book(;
    instrument_name = "BTC-PERPETUAL",
    depth = Deribit.Common.OrderBook.TEN_THOUSAND,
)

Deribit.Common.ticker(; instrument_name = "BTC-PERPETUAL")

# Spot

Deribit.Common.book_summary(;
    currency = Deribit.Common.BookSummary.BTC,
    kind = Deribit.Common.BookSummary.spot,
)

Deribit.Common.instrument(;
    currency = Deribit.Common.Instrument.BTC,
    kind = Deribit.Common.Instrument.spot,
)

# Future

Deribit.Common.book_summary(;
    currency = Deribit.Common.BookSummary.BTC,
    kind = Deribit.Common.BookSummary.future,
)

Deribit.Common.instrument(;
    currency = Deribit.Common.Instrument.BTC,
    kind = Deribit.Common.Instrument.future,
)

# Option

Deribit.Common.book_summary(;
    currency = Deribit.Common.BookSummary.BTC,
    kind = Deribit.Common.BookSummary.option,
)

Deribit.Common.instrument(;
    currency = Deribit.Common.Instrument.BTC,
    kind = Deribit.Common.Instrument.option,
)
