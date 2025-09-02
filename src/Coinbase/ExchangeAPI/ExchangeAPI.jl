module ExchangeAPI

using CryptoExchangeAPIs.Coinbase

"""
    public_client = CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")
"""
const public_client = CoinbaseClient(; base_url = "https://api.exchange.coinbase.com")

include("ProductsCandles.jl")
using .ProductsCandles

include("Currencies.jl")
using .Currencies

include("WithdrawalsFeeEstimate.jl")
using .WithdrawalsFeeEstimate

include("Products.jl")
using .Products

include("ProductsTicker.jl")
using .ProductsTicker

end
