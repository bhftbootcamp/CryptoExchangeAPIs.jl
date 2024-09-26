module Common

using CryptoExchangeAPIs.Okex

"""
    public_client = OkexClient(; base_url = "https://www.okx.com")
"""
const public_client =
    OkexClient(; base_url = "https://www.okx.com")

include("API/Instrument.jl")
using .Instrument

include("API/Ticker.jl")
using .Ticker

end