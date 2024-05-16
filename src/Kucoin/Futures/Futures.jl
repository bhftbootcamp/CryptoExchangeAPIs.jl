module Futures

using CryptoAPIs.Kucoin

"""
    public_client = KucoinClient(; base_url = "https://api-futures.kucoin.com")
"""
const public_client =
    KucoinClient(; base_url = "https://api-futures.kucoin.com")

include("API/Candle.jl")
using .Candle    

include("API/Contract.jl")
using .Contract

include("API/PrivateFundingHistory.jl")
using .PrivateFundingHistory

include("API/PublicFundingHistory.jl")
using .PublicFundingHistory

end
