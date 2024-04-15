module Futures

using CryptoAPIs.Gateio

"""
    public_client = GateioClient(; base_url = "https://api.gateio.ws")
"""
const public_client =
    GateioClient(; base_url = "https://api.gateio.ws")

include("API/Contracts.jl")
using .Contracts

end
