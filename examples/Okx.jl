# Okx Examples
# https://www.okx.com/docs-v5/en/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Okx


Okx.API.V5.Public.instruments(
    instType = Okx.API.V5.Public.Instruments.InstType.SWAP
)

Okx.API.V5.Public.instruments(
    instType = Okx.API.V5.Public.Instruments.InstType.SPOT,
    instId = "BTC-USD"
)

Okx.API.V5.Public.instruments(
    instType = Okx.API.V5.Public.Instruments.InstType.OPTION,
    uly = "BTC-USD"
)

Okx.API.V5.Market.tickers(
    instType = Okx.API.V5.Market.Tickers.InstType.SPOT,
)

Okx.API.V5.Market.tickers(
    instType = Okx.API.V5.Market.Tickers.InstType.FUTURES,
    instFamily = "BTC-USD"
)

Okx.API.V5.Market.tickers(
    instType = Okx.API.V5.Market.Tickers.InstType.OPTION,
    uly = "ETH-USD"
)

Okx.API.V5.Market.candles(instId = "BTC-USDT")

Okx.API.V5.Market.candles(
    instId = "BTC-USDT",
    bar = Okx.API.V5.Market.Candles.TimeInterval.d1,
    after = now(UTC) - Day(6),
    before = now(UTC)
)

Okx.API.V5.Public.insurance_fund(
    instType = Okx.API.V5.Public.InsuranceFund.InstType.FUTURES,
    instFamily = "BTC-USDT",
)
