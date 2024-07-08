using Serde
using CryptoAPIs.Aevo


CryptoAPIs.Aevo.Derivatives.funding_rate(; 
    instrument_name = "ETH-PERP",
)

Aevo.Derivatives.product_stats(; 
    asset = "ETH",
    instrument_type = Aevo.Derivatives.ProductStats.PERPETUAL
)

