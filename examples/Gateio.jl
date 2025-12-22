# Gateio Examples
# https://www.gate.io/docs/developers/apiv4/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Gateio


gateio_client = GateioClient(;
    base_url = "https://api.gateio.ws",
    public_key = get(ENV, "GATEIO_PUBLIC_KEY", ""),
    secret_key = get(ENV, "GATEIO_SECRET_KEY", ""),
)

Gateio.API.V4.Spot.currencies()

Gateio.API.V4.Spot.currency_pairs()

Gateio.API.V4.Spot.currency_pair(;
    currency_pair = "BTC_USDT"
)

Gateio.API.V4.Spot.tickers()

Gateio.API.V4.Spot.tickers(;
    currency_pair = "ETH_USDT"
)

Gateio.API.V4.Spot.candlesticks(;
    currency_pair = "BTC_USDT"
)

Gateio.API.V4.Spot.candlesticks(;
    currency_pair = "BTC_USDT",
    interval = Gateio.API.V4.Spot.Candlesticks.TimeInterval.d1
)

Gateio.API.V4.Spot.candlesticks(;
    currency_pair = "ETH_USDT",
    interval = Gateio.API.V4.Spot.Candlesticks.TimeInterval.h1,
    from = now(UTC) - Day(1),
    to = now(UTC)
)

Gateio.API.V4.Futures.contracts(;
    settle = Gateio.API.V4.Futures.Contracts.Settle.usdt
)

Gateio.API.V4.Futures.contracts(;
    settle = Gateio.API.V4.Futures.Contracts.Settle.usdt,
    limit = 10,
    offset = 10
)

Gateio.API.V4.Futures.tickers(;
    settle = Gateio.API.V4.Futures.Tickers.Settle.usdt
)

Gateio.API.V4.Futures.tickers(;
    settle = Gateio.API.V4.Futures.Tickers.Settle.usdt,
    contract = "BTC_USDT"
)

Gateio.API.V4.Futures.candlesticks(;
    type = Gateio.API.V4.Futures.Candlesticks.ContractType.mark,
    name = "BTC_USDT",
    settle = Gateio.API.V4.Futures.Candlesticks.Settle.usdt
)

Gateio.API.V4.Futures.candlesticks(;
    type = Gateio.API.V4.Futures.Candlesticks.ContractType.mark,
    name = "ETH_USDT",
    settle = Gateio.API.V4.Futures.Candlesticks.Settle.usdt,
    interval = Gateio.API.V4.Futures.Candlesticks.TimeInterval.d1,
    from = now(UTC) - Day(6),
    to = now(UTC),
)

Gateio.API.V4.Futures.funding_rate(;
    settle = Gateio.API.V4.Futures.FundingRate.Settle.usdt,
    contract = "ETH_USDT",
    limit = 10
)

Gateio.API.V4.Futures.order_book(;
    settle = Gateio.API.V4.Futures.OrderBook.Settle.usdt,
    contract = "ETH_USDT",
    limit = 20
)

Gateio.API.V4.Wallet.deposits(gateio_client)

Gateio.API.V4.Wallet.deposits(
    gateio_client;
    currency = "BTC"
)

Gateio.API.V4.Wallet.deposits(
    gateio_client;
    from = now(UTC) - Day(30),
    to = now(UTC)
)

Gateio.API.V4.Wallet.currency_chains(;
    currency = "BTC"
)


Gateio.API.V4.Delivery.contracts(;
    settle = Gateio.API.V4.Delivery.Contracts.Settle.usdt
)