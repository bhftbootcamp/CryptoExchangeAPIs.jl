# Mexc Examples
# https://www.mexc.com/api-docs/spot-v3/introduction

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Mexc

# --- Spot --------------------------------------------------------------------

Mexc.API.V3.exchange_info()
Mexc.API.V3.exchange_info(; symbol = "ADAUSDT")
Mexc.API.V3.exchange_info(; symbols = ["ADAUSDT", "ETHUSDT", "BTCUSDT"])

Mexc.API.V3.ticker24hr()
Mexc.API.V3.ticker24hr(; symbol = "ADAUSDT")

spot_client = Mexc.MexcSpotClient(
    base_url = "https://api.mexc.com",
    public_key = ENV["MEXC_PUBLIC_KEY"],
    secret_key = ENV["MEXC_SECRET_KEY"],
)

Mexc.API.V3.Capital.Config.getall(spot_client)

# --- Futures -----------------------------------------------------------------

Mexc.API.V1.Contract.detail()
Mexc.API.V1.Contract.detail(; symbol = "ADA_USDT")

Mexc.API.V1.Contract.ticker()
Mexc.API.V1.Contract.ticker(; symbol = "ADA_USDT")
