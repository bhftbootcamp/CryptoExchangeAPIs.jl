module Spot

using CryptoExchangeAPIs.Okex

"""
    public_client = OkexClient(; base_url = "https://www.okex.com")
"""
const public_client =
    OkexClient(; base_url = "https://www.okex.com")

include("API/Candle.jl")
using .Candle

include("API/Currency.jl")
using .Currency

end
