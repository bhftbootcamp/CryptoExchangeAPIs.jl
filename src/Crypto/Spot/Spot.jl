module Spot

using CryptoAPIs.Crypto

"""
    public_client = CryptoClient(; base_url = "https://api.crypto.com/exchange/v1")
"""
const public_client =
    CryptoClient(; base_url = "https://api.crypto.com/exchange/v1")

include("API/Candle.jl")
using .Candle

end
