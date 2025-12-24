# Bitget Examples
# https://www.bitget.com/api-doc/common/intro

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bitget


Bitget.API.V2.Spot.Public.coins()
Bitget.API.V2.Spot.Public.coins(; coin = "BTC")

Bitget.API.V2.Spot.Public.symbols()
Bitget.API.V2.Spot.Public.symbols(; symbol = "BTCUSDT")

Bitget.API.V2.Spot.Market.tickers()
Bitget.API.V2.Spot.Market.tickers(; symbol = "BTCUSDT")

Bitget.API.V2.Mix.Market.contracts(
    productType = Bitget.API.V2.Mix.Market.Contracts.SettleType.USDT_FUTURES,
)
Bitget.API.V2.Mix.Market.contracts(
    productType = Bitget.API.V2.Mix.Market.Contracts.SettleType.USDT_FUTURES,
    symbol = "BTCUSDT",
)

Bitget.API.V2.Mix.Market.tickers(
    productType = Bitget.API.V2.Mix.Market.Tickers.SettleType.USDT_FUTURES,
)

Bitget.API.V2.Mix.Market.open_interest(
    productType = Bitget.API.V2.Mix.Market.OpenInterest.SettleType.USDT_FUTURES,
    symbol = "BTCUSDT",
)