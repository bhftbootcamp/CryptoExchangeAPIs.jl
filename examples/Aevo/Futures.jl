# Aevo/Futures
# https://api-docs.aevo.xyz/reference/overview

using Dates
using CryptoExchangeAPIs
using CryptoExchangeAPIs.Aevo

CryptoExchangeAPIs.Aevo.Futures.funding_rate(; 
    instrument_name = "ETH-PERP",
)

CryptoExchangeAPIs.Aevo.Futures.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Futures.ProductStats.PERPETUAL
)
