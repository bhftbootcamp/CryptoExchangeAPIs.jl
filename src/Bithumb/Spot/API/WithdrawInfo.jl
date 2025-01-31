module WithdrawInfo

using CryptoExchangeAPIs.Bithumb
using CryptoExchangeAPIs.Bithumb: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

export WithdrawInfoQuery,
 WithdrawInfoData,
 withdraw_info

Base.@kwdef mutable struct WithdrawInfoQuery <: BithumbPrivateQuery
    currency::String
    net_type::String
    signature::Maybe{String} = nothing
end

struct MemberLevel <: BithumbData
    security_level::Maybe{Int64}
    fee_level::Maybe{Int64}
    email_verified::Maybe{Bool}
    identity_auth_verified::Maybe{Bool}
    bank_account_verified::Maybe{Bool}
    two_factor_auth_verified::Maybe{Bool}
    locked::Maybe{Bool}
    wallet_locked::Maybe{Bool}
end

struct Currency <: BithumbData
    code::String
    withdraw_fee::Float64
    is_coin::Bool
    wallet_state::String
    wallet_support::Vector{String}
end

struct Account <: BithumbData
    currency::String
    balance::Float64
    locked::Float64
    avg_buy_price::Float64
    avg_buy_price_modified::Bool
    unit_currency::String
end

struct WithdrawLimit <: BithumbData
    currency::String
    minimum::Float64
    onetime::Float64
    daily::Float64
    remaining_daily::Float64
    fixed::Int64
    can_withdraw::Bool
    remaining_daily_krw::Maybe{Float64}
end

struct WithdrawInfoData <: BithumbData
    member_level::MemberLevel
    currency::Currency
    account::Account
    withdraw_limit::WithdrawLimit
end
"""
    withdraw_info(client::BithumbClient, query::WithdrawInfoQuery)
    withdraw_info(client::BithumbClient; kw...)
Retrieves detailed information about the withdrawal capabilities for a specific currency on the Bithumb exchange.
[`GET /v1/withdraws/chance`](https://apidocs.bithumb.com/reference/%EC%B6%9C%EA%B8%88-%EA%B0%80%EB%8A%A5-%EC%A0%95%EB%B3%B4)

## Description:
The `withdraw_info` function provides comprehensive details about the user's ability to withdraw a specific currency. 
This includes information about the user's verification status, currency-specific details, account balances, and withdrawal limits.

## Parameters:
| Parameter   | Type      | Required | Description                          |
|-------------|-----------|----------|--------------------------------------|
| currency    | String    | Yes      | The currency code (e.g., "BTC").     |
| net_type    | String    | Yes      | The network type (e.g., "BTC").      |

## Code samples:
```julia
using Serde
using CryptoExchangeAPIs.Bithumb

# Ensure that the environment variables BITHUMB_PUBLIC_KEY and BITHUMB_SECRET_KEY are set.
bithumb_client = Bithumb.Client(;
    base_url = "https://api.bithumb.com",
    public_key = ENV["BITHUMB_PUBLIC_KEY"],
    secret_key = ENV["BITHUMB_SECRET_KEY"],
)
result = WithdrawInfo.withdraw_info(
    bithumb_client;
    currency = "BTC",
    net_type = "BTC",
)
to_pretty_json(result.result)
```
## Result:

```json
{
  "status": "0000",
  "date": null,
  "data": {
    "member_level": {
      "security_level": 3,
      "fee_level": 1,
      "email_verified": true,
      "identity_auth_verified": true,
      "bank_account_verified": true,
      "two_factor_auth_verified": true,
      "locked": false,
      "wallet_locked": false
    },
    "currency": {
      "code": "BTC",
      "withdraw_fee": 0.0005,
      "is_coin": true,
      "wallet_state": "working",
      "wallet_support": ["KRW", "BTC"]
    },
    "account": {
      "currency": "BTC",
      "balance": 1.0,
      "locked": 0.0,
      "avg_buy_price": 10000.0,
      "avg_buy_price_modified": false,
      "unit_currency": "KRW"
    },
    "withdraw_limit": {
      "currency": "BTC",
      "minimum": 0.001,
      "onetime": 2.0,
      "daily": 5.0,
      "remaining_daily": 5.0,
      "fixed": 0,
      "can_withdraw": true,
      "remaining_daily_krw": null
    }
  }
}
```
"""
function withdraw_info(client::BithumbClient, query::WithdrawInfoQuery)
  CryptoExchangeAPIs.request_sign!(client, query, "v1/withdraws/chance")
  
  return APIsRequest{Data{WithdrawInfoData}}("GET", "v1/withdraws/chance", query)(client)
  end
  
  function withdraw_info(client::BithumbClient; kw...)
  return withdraw_info(client, WithdrawInfoQuery(; kw...))
  end
  
  end