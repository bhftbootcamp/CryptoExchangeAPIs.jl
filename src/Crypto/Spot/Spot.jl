module Spot

using CryptoAPIs.Crypto

"""
    public_client = CryptoClient(; base_url = "https://api.crypto.com/v2")
"""
const public_client =
    CryptoClient(; base_url = "https://api.crypto.com/v2")

include("API/Candle.jl")
using .Candle

end
