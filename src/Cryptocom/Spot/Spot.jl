module Spot

using CryptoAPIs.Cryptocom

"""
    public_client = CryptocomClient(; base_url = "https://api.crypto.com/exchange/v1")
"""
const public_client =
    CryptocomClient(; base_url = "https://api.crypto.com/exchange/v1")

include("API/Candle.jl")
using .Candle

include("API/GetInstruments.jl")
using .GetInstruments

include("API/Ticker.jl")
using .Ticker

end
