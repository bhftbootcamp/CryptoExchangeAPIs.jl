module Capital

include("ConfigGetall.jl")
using .ConfigGetall

include("DepositHisrec.jl")
using .DepositHisrec

include("WithdrawHistory.jl")
using .WithdrawHistory

end
