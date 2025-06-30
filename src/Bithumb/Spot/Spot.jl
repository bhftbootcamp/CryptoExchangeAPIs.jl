module Spot

using CryptoExchangeAPIs.Bithumb

"""
    public_client = BithumbClient(; base_url = "https://api.bithumb.com")
"""
const public_client = 
    BithumbClient(; base_url = "https://api.bithumb.com")

include("API/AssetStatus.jl")
using .AssetStatus

include("API/Candle.jl")
using .Candle

include("API/Market.jl")
using .Market

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

include("API/UserTransactions.jl")
using .UserTransactions

include("API/WithdrawInfo.jl")
using .WithdrawInfo

end
