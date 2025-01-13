# Bybit/Spot
# https://bybit-exchange.github.io/docs/

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Bybit

Bybit.Spot.candle(;
    category = Bybit.Spot.Candle.SPOT,
    symbol = "ADAUSDT",
    interval = Bybit.Spot.Candle.m1,
    startTime = DateTime("2022-10-27T08:00:00"),
    endTime = DateTime("2022-10-27T08:00:00") + Hour(1),
    limit = 4,
)

Bybit.Spot.order_book(; 
    category = Bybit.Spot.OrderBook.SPOT,
    symbol = "ADAUSDT",
)

Bybit.Spot.symbol_info(;
    category = Bybit.Spot.SymbolInfo.SPOT,
    symbol = "BTCUSDT",
)

Bybit.Spot.ticker(; 
    category = Bybit.Spot.Ticker.SPOT,
    symbol = "ADAUSDT",
)

bybit_client = BybitClient(;
    base_url = "https://api.bybit.com",
    public_key = ENV["BYBIT_PUBLIC_KEY"],
    secret_key = ENV["BYBIT_SECRET_KEY"],
)

Bybit.Spot.coin_info(bybit_client)

Bybit.Spot.deposit(bybit_client)

Bybit.Spot.trade_history(bybit_client; category = Bybit.Spot.TradeHistory.SPOT, limit = 1)
