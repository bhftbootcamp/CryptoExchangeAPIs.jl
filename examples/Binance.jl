# Binance Examples
# https://www.binance.com/en/binance-api

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Binance


api_client = BinanceClient(;
    base_url = "https://api.binance.com",
    public_key = get(ENV, "BINANCE_PUBLIC_KEY", ""),
    secret_key = get(ENV, "BINANCE_SECRET_KEY", ""),
)

fapi_client = BinanceClient(;
    base_url = "https://fapi.binance.com",
    public_key = get(ENV, "BINANCE_PUBLIC_KEY", ""),
    secret_key = get(ENV, "BINANCE_SECRET_KEY", ""),
)

dapi_client = BinanceClient(;
    base_url = "https://dapi.binance.com",
    public_key = get(ENV, "BINANCE_PUBLIC_KEY", ""),
    secret_key = get(ENV, "BINANCE_SECRET_KEY", ""),
)


Binance.API.V3.avg_price(; symbol = "ADAUSDT")

Binance.API.V3.klines(;
    symbol = "BTCUSDT",
    interval = Binance.API.V3.Klines.TimeInterval.h1
)

Binance.API.V3.klines(;
    symbol = "BTCUSDT",
    interval = Binance.API.V3.Klines.TimeInterval.m15,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 4
)

Binance.API.V3.depth(; symbol = "BTCUSDT", limit = 10)

Binance.API.V3.exchange_info()

Binance.API.V3.exchange_info(; symbol = "BTCUSDT")

Binance.API.V3.exchange_info(; symbols = ["BTCUSDT", "ETHUSDT", "ADAUSDT"])

Binance.API.V3.exchange_info(;
    permissions = [
        Binance.API.V3.ExchangeInfo.Permission.SPOT,
        Binance.API.V3.ExchangeInfo.Permission.MARGIN,
    ]
)

Binance.API.V3.time()

Binance.API.V3.ticker24hr(; symbol = "BTCUSDT")

Binance.API.V3.ticker24hr(; symbols = ["BTCUSDT", "ADAUSDT", "ETHUSDT"])

Binance.API.V3.ticker24hr(; type = Binance.API.V3.Ticker24hr.TickerType.FULL)

Binance.API.V3.ticker24hr()

Binance.API.V3.my_trades(api_client; symbol = "BTCUSDT")

Binance.SAPI.V1.Capital.Config.getall(api_client)

Binance.SAPI.V1.Capital.Deposit.hisrec(api_client)

Binance.SAPI.V1.Capital.Deposit.hisrec(api_client;
    coin = "BTC",
    status = Binance.SAPI.V1.Capital.Deposit.Hisrec.DepositStatus.SUCCESS,
    startTime = now(UTC) - Day(1),
    endTime = now(UTC),
    limit = 100
)

Binance.SAPI.V1.Capital.Withdraw.history(api_client)

Binance.SAPI.V1.Capital.Withdraw.history(api_client;
    coin = "USDT",
    status = Binance.SAPI.V1.Capital.Withdraw.History.WithdrawStatus.COMPLETED,
    startTime = now(UTC) - Month(1),
    endTime = now(UTC),
    limit = 100
)


Binance.FAPI.V1.klines(;
    symbol = "BTCUSDT",
    interval = Binance.FAPI.V1.Klines.TimeInterval.m5
)

Binance.FAPI.V1.klines(;
    symbol = "BTCUSDT",
    interval = Binance.FAPI.V1.Klines.TimeInterval.h1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 5
)

Binance.FAPI.V1.continuous_klines(;
    pair = "BTCUSDT",
    contractType = Binance.FAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
    interval = Binance.FAPI.V1.ContinuousKlines.TimeInterval.m1
)

Binance.FAPI.V1.continuous_klines(;
    pair = "BTCUSDT",
    contractType = Binance.FAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
    interval = Binance.FAPI.V1.ContinuousKlines.TimeInterval.m1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 10,
)

Binance.FAPI.V1.exchange_info()

Binance.FAPI.V1.funding_rate(; symbol = "BTCUSDT")

Binance.FAPI.V1.funding_rate(;
    symbol = "BTCUSDT",
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 10
)

Binance.FAPI.V1.historical_trades(fapi_client; symbol = "BTCUSDT")

Binance.FAPI.V1.depth(; symbol = "BTCUSDT")

Binance.FAPI.V1.premium_index(; symbol = "BTCUSDT")

Binance.FAPI.V1.ticker24hr(; symbol = "BTCUSDT")

Binance.FAPI.V1.insurance_balance()

Binance.FAPI.V1.insurance_balance(; symbol = "BTCUSDT")


Binance.Futures.Data.global_long_short_account_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.GlobalLongShortAccountRatio.TimeInterval.h1
)

Binance.Futures.Data.open_interest_hist(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.OpenInterestHist.TimeInterval.h1
)

Binance.Futures.Data.taker_long_short_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.TakerLongShortRatio.TimeInterval.h1
)

Binance.Futures.Data.top_long_short_account_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.TopLongShortAccountRatio.TimeInterval.h1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 10,
)

Binance.Futures.Data.top_long_short_position_ratio(;
    symbol = "BTCUSDT",
    period = Binance.Futures.Data.TopLongShortPositionRatio.TimeInterval.h1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 10,
)


Binance.DAPI.V1.klines(;
    symbol = "BTCUSD_PERP",
    interval = Binance.DAPI.V1.Klines.TimeInterval.m5
)

Binance.DAPI.V1.klines(;
    symbol = "BTCUSD_PERP",
    interval = Binance.DAPI.V1.Klines.TimeInterval.h4,
    startTime = now(UTC) - Day(1),
    endTime = now(UTC),
    limit = 10,
)

Binance.DAPI.V1.continuous_klines(;
    pair = "BTCUSD",
    contractType = Binance.DAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
    interval = Binance.DAPI.V1.ContinuousKlines.TimeInterval.m1
)

Binance.DAPI.V1.continuous_klines(;
    pair = "BTCUSD",
    contractType = Binance.DAPI.V1.ContinuousKlines.ContractType.PERPETUAL,
    interval = Binance.DAPI.V1.ContinuousKlines.TimeInterval.m1,
    startTime = now(UTC) - Hour(1),
    endTime = now(UTC),
    limit = 10,
)

Binance.DAPI.V1.exchange_info()

Binance.DAPI.V1.funding_rate(; symbol = "BTCUSD_PERP")

Binance.DAPI.V1.depth(; symbol = "BTCUSD_PERP", limit = 10)

Binance.DAPI.V1.premium_index(; pair = "BTCUSD")

Binance.DAPI.V1.premium_index(; symbol = "BTCUSD_PERP")

Binance.DAPI.V1.ticker24hr(; pair = "BTCUSD")

Binance.DAPI.V1.ticker24hr(; symbol = "BTCUSD_PERP")

Binance.DAPI.V1.income(
    dapi_client;
    symbol = "BTCUSD_PERP",
    incomeType = "COMMISSION",
    startTime = now(UTC) - Day(1),
    endTime = now(UTC),
    limit = 100
)


Binance.BAPI.DEFI.V1.Public.Alpha.token_list()
