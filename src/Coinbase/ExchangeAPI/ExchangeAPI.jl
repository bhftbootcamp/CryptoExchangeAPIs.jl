module ExchangeAPI

using CryptoExchangeAPIs.Coinbase

"""
    public_client = CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")
"""
const public_client = CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")

include("Currencies/Currencies.jl")
using .Currencies

include("Products/Products.jl")
using .Products

include("Withdrawals/Withdrawals.jl")
using .Withdrawals

end
