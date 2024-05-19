# Deribit/Common
# https://docs.deribit.com/

using Dates
using CryptoAPIs
using CryptoAPIs.Deribit

CryptoAPIs.Deribit.Common.book_summary(; currency = CryptoAPIs.Deribit.Common.BookSummary.BTC)

CryptoAPIs.Deribit.Common.candle(
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = now(UTC) - Minute(100),
    end_timestamp = now(UTC) - Hour(1),
    resolution = CryptoAPIs.Deribit.Common.Candle.m1,
)

CryptoAPIs.Deribit.Common.funding_rate(;
    instrument_name = "BTC-PERPETUAL",
    start_timestamp = Dates.DateTime("2022-11-08"),
    end_timestamp = Dates.DateTime("2022-11-08") + Day(2),
)

CryptoAPIs.Deribit.Common.instrument(;
    currency = CryptoAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoAPIs.Deribit.Common.Instrument.spot,
)

CryptoAPIs.Deribit.Common.instrument(;
    currency = CryptoAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoAPIs.Deribit.Common.Instrument.future,
)

CryptoAPIs.Deribit.Common.instrument(;
    currency = CryptoAPIs.Deribit.Common.Instrument.BTC,
    kind = CryptoAPIs.Deribit.Common.Instrument.option,
)

CryptoAPIs.Deribit.Common.order_book(;
    instrument_name = "BTC-PERPETUAL",
    depth = CryptoAPIs.Deribit.Common.OrderBook.TEN_THOUSAND,
)

CryptoAPIs.Deribit.Common.ticker(; instrument_name = "BTC-PERPETUAL")
