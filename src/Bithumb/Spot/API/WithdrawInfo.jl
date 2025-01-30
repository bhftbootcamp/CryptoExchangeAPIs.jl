module WithdrawInfo

Base.@kwdef mutable struct WithdrawInfoQuery <: PrivateQuery
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

struct WithdrawInfo <: AbstractResult
    member_level::MemberLevel
    currency::Currency
    account::Account
    withdraw_limit::WithdrawLimit
end

security_level(x::WithdrawInfo) = x.member_level.security_level
fee_level(x::WithdrawInfo) = x.member_level.fee_level
email_verified(x::WithdrawInfo) = x.member_level.email_verified
identity_auth_verified(x::WithdrawInfo) = x.member_level.identity_auth_verified
bank_account_verified(x::WithdrawInfo) = x.member_level.bank_account_verified
two_factor_auth_verified(x::WithdrawInfo) = x.member_level.two_factor_auth_verified
member_level_locked(x::WithdrawInfo) = x.member_level.locked
wallet_locked(x::WithdrawInfo) = x.member_level.wallet_locked
code(x::WithdrawInfo) = x.currency.code
withdraw_fee(x::WithdrawInfo) = x.currency.withdraw_fee
is_coin(x::WithdrawInfo) = x.currency.is_coin
wallet_state(x::WithdrawInfo) = x.currency.wallet_state
wallet_support(x::WithdrawInfo) = x.currency.wallet_support
account_currency(x::WithdrawInfo) = x.account.currency
balance(x::WithdrawInfo) = x.account.balance
account_locked(x::WithdrawInfo) = x.account.locked
avg_buy_price(x::WithdrawInfo) = x.account.avg_buy_price
avg_buy_price_modified(x::WithdrawInfo) = x.account.avg_buy_price_modified
unit_currency(x::WithdrawInfo) = x.account.unit_currency
withdraw_limit_currency(x::WithdrawInfo) = x.withdraw_limit.currency
minimum(x::WithdrawInfo) = x.withdraw_limit.minimum
onetime(x::WithdrawInfo) = x.withdraw_limit.onetime
daily(x::WithdrawInfo) = x.withdraw_limit.daily
remaining_daily(x::WithdrawInfo) = x.withdraw_limit.remaining_daily
fixed(x::WithdrawInfo) = x.withdraw_limit.fixed
can_withdraw(x::WithdrawInfo) = x.withdraw_limit.can_withdraw
remaining_daily_krw(x::WithdrawInfo) = x.withdraw_limit.remaining_daily_krw


"""
    withdraw_info(client::Client; $(CCTX.query_info(WithdrawInfoQuery)))
Check the possible withdrawal information of the currency.
https://apidocs.bithumb.com/reference/%EC%B6%9C%EA%B8%88-%EA%B0%80%EB%8A%A5-%EC%A0%95%EB%B3%B4
"""
function withdraw_info(client::Client, query::WithdrawInfoQuery)
    return CctxQuery{WithdrawInfo}("GET", "v1/withdraws/chance", query)(client)
end

function withdraw_info(client::Client; kw...)
    return withdraw_info(client, WithdrawInfoQuery(; kw...))
end

end