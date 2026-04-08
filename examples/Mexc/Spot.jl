# Mexc/Spot

using Serde
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Mexc

# Server Time
result = Mexc.Spot.server_time()
println(to_pretty_json(result.result))

# Exchange Info
result = Mexc.Spot.exchange_info(; symbol = "BTCUSDT")
println(to_pretty_json(result.result))

# Average Price
result = Mexc.Spot.avg_price(; symbol = "BTCUSDT")
println(to_pretty_json(result.result))

# Order Book
result = Mexc.Spot.order_book(; symbol = "BTCUSDT", limit = 5)
println(to_pretty_json(result.result))

# Candle
result = Mexc.Spot.candle(;
    symbol = "BTCUSDT",
    interval = Mexc.Spot.Candle.d1,
    limit = 3,
)
println(to_pretty_json(result.result))

# Ticker 24hr
result = Mexc.Spot.ticker(; symbol = "BTCUSDT")
println(to_pretty_json(result.result))

# Private endpoints (require API keys)
# mexc_client = MexcClient(;
#     base_url = "https://api.mexc.com",
#     public_key = ENV["MEXC_PUBLIC_KEY"],
#     secret_key = ENV["MEXC_SECRET_KEY"],
# )

# Account Trades
# result = Mexc.Spot.account_trade(mexc_client; symbol = "BTCUSDT")
# println(to_pretty_json(result.result))

# Coin Information
# result = Mexc.Spot.coin_information(mexc_client)
# println(to_pretty_json(result.result))

# Deposit Log
# result = Mexc.Spot.deposit_log(mexc_client)
# println(to_pretty_json(result.result))

# Withdrawal Log
# result = Mexc.Spot.withdrawal_log(mexc_client)
# println(to_pretty_json(result.result))
