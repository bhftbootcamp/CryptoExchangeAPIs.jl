# Aevo/Futures
# https://api-docs.aevo.xyz/reference/overview

using Dates
using CryptoAPIs
using CryptoAPIs.Aevo


CryptoAPIs.Aevo.Futures.funding_rate(; 
    instrument_name = "ETH-PERP",
)

CryptoAPIs.Aevo.Futures.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Futures.ProductStats.PERPETUAL
)
