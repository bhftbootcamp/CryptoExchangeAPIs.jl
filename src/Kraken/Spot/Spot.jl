module Spot

using CryptoAPIs.Kraken

"""
    public_client = KrakenClient(; base_url = "https://api.kraken.com")
"""
const public_client = 
    KrakenClient(; base_url = "https://api.kraken.com")

include("API/Asset.jl")
using .Asset

include("API/AssetPair.jl")
using .AssetPair

include("API/Candle.jl")
using .Candle

include("API/DepositLog.jl")
using .DepositLog

include("API/DepositMethod.jl")
using .DepositMethod

include("API/LedgerInfoLog.jl")
using .LedgerInfoLog

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

include("API/WithdrawalLog.jl")
using .WithdrawalLog

include("API/WithdrawalMethod.jl")
using .WithdrawalMethod

end
