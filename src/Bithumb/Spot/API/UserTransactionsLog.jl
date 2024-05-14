module UserTransactionsLog

export UserTransactionsLogQuery,
    UserTransactionsLogData,
    user_transactions_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Bithumb
using CryptoAPIs.Bithumb: Data
using CryptoAPIs: Maybe, APIsRequest

@enum SearchStatus begin
    ALL            = 0
    BUY_COMPLETED  = 1
    SELL_COMPLETED = 2
    WITHDRAWAL     = 3
    DEPOSIT        = 4
    RECALL         = 5
    DEPOSITING_KRW = 9
end

function Serde.SerQuery.ser_type(::Type{<:BithumbPrivateQuery}, x::SearchStatus)::Int64
    return Int64(x)
end

Base.@kwdef mutable struct UserTransactionsLogQuery <: BithumbPrivateQuery
    order_currency::String
    payment_currency::String
    count::Int64 = 20
    offset::Maybe{Int64} = nothing
    searchGb::Maybe{SearchStatus} = nothing

    nonce::Maybe{DateTime} = nothing
    endpoint::Maybe{String} = nothing
    signature::Maybe{String} = nothing
end

struct UserTransactionsLogData <: BithumbData
    amount::Float64
    fee::Float64
    fee_currency::String
    order_balance::Float64
    order_currency::String
    payment_balance::Float64
    payment_currency::String
    price::Float64
    search::SearchStatus
    transfer_date::NanoDate
    units::Float64
end

function Serde.deser(::Type{<:UserTransactionsLogData}, ::Type{<:Maybe{Float64}}, x::String)::Float64
    return parse(Float64, replace(x, "," => "", " " => ""))
end

"""
    user_transactions_log(client::BithumbClient, query::UserTransactionsLogQuery)
    user_transactions_log(client::BithumbClient; kw...)

[`POST /info/user_transactions`](https://apidocs.bithumb.com/reference/거래-체결내역-조회)

## Parameters:

| Parameter        | Type         | Required | Description |
|:-----------------|:-------------|:---------|:------------|
| order_currency   | String       | true     |             |
| payment_currency | String       | true     |             |
| count            | Int64        | false    | Default: 20 |
| offset           | Int64        | false    |             |
| searchGb         | SearchStatus | false    | ALL (0), BUY\\_COMPLETED (1), SELL\\_COMPLETED (2), WITHDRAWAL (3), DEPOSIT (4), RECALL (5), DEPOSITING\\_KRW (9) |
| nonce            | DateTime     | false    |             |
| endpoint         | String       | false    |             |
| signature        | String       | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Bithumb

bithumb_client = Bithumb.Client(;
    base_url = "https://api.bithumb.com",
    public_key = ENV["BITHUMB_PUBLIC_KEY"],
    secret_key = ENV["BITHUMB_SECRET_KEY"],
)

result = Bithumb.Spot.user_transactions_log(
    bithumb_client;
    order_currency = "ETH",
    payment_currency = "BTC",
    count = 50,
    searchGb = Bithumb.Spot.UserTransactionsLog.ALL,
)

to_pretty_json(result.result)
```

## Result:

```json

```
"""
function user_transactions_log(client::BithumbClient, query::UserTransactionsLogQuery)
    return APIsRequest{Data{Vector{UserTransactionsLogData}}}("POST", "info/user_transactions", query)(client)
end

function user_transactions_log(client::BithumbClient = Bithumb.Spot.public_client; kw...)
    return user_transactions_log(client, UserTransactionsLogQuery(; kw...))
end

end
