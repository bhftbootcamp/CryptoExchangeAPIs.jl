module WithdrawInfo

using CryptoExchangeAPIs.Bithumb: BithumbPrivateQuery, BithumbData, Data
using CryptoExchangeAPIs: Maybe, APIsRequest
using Dates, NanoDates, TimeZones

Base.@kwdef mutable struct WithdrawInfoQuery <: BithumbPrivateQuery
    currency::String
    net_type::String
    signature::Maybe{String} = nothing
end

struct MemberLevel
    security_level::Maybe{Int64}
    fee_level::Maybe{Int64}
    email_verified::Maybe{Bool}
    identity_auth_verified::Maybe{Bool}
    bank_account_verified::Maybe{Bool}
    two_factor_auth_verified::Maybe{Bool}
    locked::Maybe{Bool}
    wallet_locked::Maybe{Bool}
end

struct Currency
    code::String
    withdraw_fee::Float64
    is_coin::Bool
    wallet_state::String
    wallet_support::Vector{String}
end

struct Account
    currency::String
    balance::Float64
    locked::Float64
    avg_buy_price::Float64
    avg_buy_price_modified::Bool
    unit_currency::String
end

struct WithdrawLimit
    currency::String
    minimum::Float64
    onetime::Float64
    daily::Float64
    remaining_daily::Float64
    fixed::Int64
    can_withdraw::Bool
    remaining_daily_krw::Maybe{Float64}
end

struct WithdrawInfo <: BithumbData
    member_level::MemberLevel
    currency::Currency
    account::Account
    withdraw_limit::WithdrawLimit
end

"""
    withdraw_info(client::BithumbClient, query::WithdrawInfoQuery)
Check the possible withdrawal information of the currency.
https://apidocs.bithumb.com/reference/%EC%B6%9C%EA%B8%88-%EA%B0%80%EB%8A%A5-%EC%A0%95%EB%B3%B4
"""
function withdraw_info(client::BithumbClient, query::WithdrawInfoQuery)
    CryptoExchangeAPIs.request_sign!(client, query, "v1/withdraws/chance")
    
    return APIsRequest{Data{WithdrawInfo}}("GET", "v1/withdraws/chance", query)(client)
end

function withdraw_info(client::BithumbClient; kw...)
    return withdraw_info(client, WithdrawInfoQuery(; kw...))
end

end 
