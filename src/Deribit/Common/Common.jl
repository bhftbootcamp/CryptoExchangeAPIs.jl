module Common

using CryptoExchangeAPIs.Deribit

"""
    public_client = DeribitClient(; base_url = "https://www.deribit.com")
"""
const public_client =
    DeribitClient(; base_url = "https://www.deribit.com")

include("API/BookSummary.jl")
using .BookSummary

include("API/Candle.jl")
using .Candle

include("API/FundingRate.jl")
using .FundingRate

include("API/Instrument.jl")
using .Instrument

include("API/OrderBook.jl")
using .OrderBook

include("API/Ticker.jl")
using .Ticker

end