module V3

include("Capital/Capital.jl")
using .Capital

include("ExchangeInfo.jl")
using .ExchangeInfo

include("Ticker24hr.jl")
using .Ticker24hr

include("AccountTrade.jl")
using .AccountTrade

include("AvgPrice.jl")
using .AvgPrice

include("Candle.jl")
using .Candle

include("CoinInformation.jl")
using .CoinInformation

include("DepositLog.jl")
using .DepositLog

include("OrderBook.jl")
using .OrderBook

include("ServerTime.jl")
using .ServerTime

include("WithdrawalLog.jl")
using .WithdrawalLog

end
