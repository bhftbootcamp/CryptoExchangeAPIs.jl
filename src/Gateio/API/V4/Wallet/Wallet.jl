module Wallet

include("Deposits.jl")
using .Deposits

include("CurrencyChains.jl")
using .CurrencyChains

include("WithdrawStatus.jl")
using .WithdrawStatus

end
