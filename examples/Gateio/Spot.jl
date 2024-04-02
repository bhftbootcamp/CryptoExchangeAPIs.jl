# Gateio/Spot
# https://www.gate.io/docs/developers/apiv4

using Dates
using CryptoAPIs
using CryptoAPIs.Gateio

CryptoAPIs.Gateio.Spot.candle(;
    currency_pair = "BTC_USDT",
    interval = Gateio.Spot.Candle.d1,
)

CryptoAPIs.Gateio.Spot.ticker(currency_pair = "BTC_USDT")

gateio_client = GateioClient(;
    base_url = "https://api.gateio.ws",
    public_key = ENV["GATEIO_PUBLIC_KEY"],
    secret_key = ENV["GATEIO_SECRET_KEY"],
)

CryptoAPIs.Gateio.Spot.deposit(gateio_client)
