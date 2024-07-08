using Serde
using CryptoAPIs
using CryptoAPIs.Aevo


CryptoAPIs.Aevo.Derivatives.funding_rate(; 
    instrument_name = "ETH-PERP",
)

CryptoAPIs.Aevo.Derivatives.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Derivatives.ProductStats.PERPETUAL
)
