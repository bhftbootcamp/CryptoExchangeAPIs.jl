# Deribit/Common
# https://docs.deribit.com/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Deribit

# Common

CryptoExchangeAPIs.Deribit.Common.candle(
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Minute(100),
    end_timestamp = now(UTC) - Hour(1),
    resolution = CryptoExchangeAPIs.Deribit.Common.Candle.m1,
)

CryptoExchangeAPIs.Deribit.Common.funding_rate(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = Dates.DateTime("2022-11-08"),
    end_timestamp = Dates.DateTime("2022-11-08") + Day(2),
)

CryptoExchangeAPIs.Deribit.Common.order_book(;
    instrument_name = "BTC-PERPETUAL",
    depth = CryptoExchangeAPIs.Deribit.Common.OrderBook.TEN_THOUSAND,
)

CryptoExchangeAPIs.Deribit.Common.ticker(; instrument_name = "BTC-PERPETUAL")

# Spot

CryptoExchangeAPIs.Deribit.Common.book_summary(;
    currency = CryptoExchangeAPIs.Deribit.Common.BookSummary.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.BookSummary.spot,
)

CryptoExchangeAPIs.Deribit.Common.instrument(;
    currency = CryptoExchangeAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.Instrument.spot,
)

# Future

CryptoExchangeAPIs.Deribit.Common.book_summary(;
    currency = CryptoExchangeAPIs.Deribit.Common.BookSummary.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.BookSummary.future,
)

CryptoExchangeAPIs.Deribit.Common.instrument(;
    currency = CryptoExchangeAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.Instrument.future,
)

# Option

CryptoExchangeAPIs.Deribit.Common.book_summary(;
    currency = CryptoExchangeAPIs.Deribit.Common.BookSummary.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.BookSummary.option,
)

CryptoExchangeAPIs.Deribit.Common.instrument(;
    currency = CryptoExchangeAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoExchangeAPIs.Deribit.Common.Instrument.option,
)
