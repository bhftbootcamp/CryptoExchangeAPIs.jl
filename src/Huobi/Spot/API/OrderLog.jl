module OrderLog

export OrderLogQuery,
    OrderLogData,
    order_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoExchangeAPIs.Huobi
using CryptoExchangeAPIs.Huobi: Data
using CryptoExchangeAPIs: Maybe, APIsRequest

@enum DirectQuery begin
    prev
    next
end

Base.@kwdef mutable struct OrderLogQuery <: HuobiPrivateQuery
    AccessKeyId::Maybe{String} = nothing        # The 'Public Key' in your API Key
    Signature::Maybe{String} = nothing
    SignatureMethod::Maybe{String} = nothing    # The Hash method that is used to sign, it uses HmacSHA256
    SignatureVersion::Maybe{String} = nothing   # The version for the signature protocol, it uses 2
    Timestamp::Maybe{DateTime} = nothing

    direct::Maybe{DirectQuery} = nothing        # Direction of the query.
    end_time::Maybe{DateTime} = nothing         # End time (included). Default The query time. UTC time in millisecond
    size::Maybe{Int64} = nothing                # Number of items in each response [10-1000]
    start_time::Maybe{DateTime} = nothing       # Start time (included). Default the time 48 hours ago. UTC time in millisecond
    symbol::Maybe{String} = nothing             # The trading symbol to trade
end

struct OrderLogData <: HuobiData
    field_fees::Maybe{Float64}
    price::Float64
    state::String
    canceled_at::Maybe{Int64}
    client_order_id::Maybe{Int64}
    amount::Float64
    field_amount::Maybe{Float64}
    created_at::Maybe{NanoDate}
    account_id::Maybe{Int64}
    field_cash_amount::Maybe{Float64}
    finished_at::Maybe{Int64}
    symbol::String
    id::Int64
    type::String
    source::String
end

"""
    order_log(client::HuobiClient, query::OrderLogQuery)
    order_log(client::HuobiClient; kw...)

This endpoint returns orders based on a specific searching criteria. The orders created via API will no longer be queryable after being cancelled for more than 2 hours.

[`GET v1/order/history`](https://huobiapi.github.io/docs/spot/v1/en/#search-past-orders)

## Parameters:

| Parameter        | Type        | Required | Description   |
|:-----------------|:------------|:---------|:--------------|
| AccessKeyId      | String      | false    |               |
| Signature        | String      | false    |               |
| SignatureMethod  | String      | false    |               |
| SignatureVersion | String      | false    |               |
| Timestamp        | DateTime    | false    |               |
| direct           | DirectQuery | false    | `prev` `next` |
| end_time         | DateTime    | false    |               |
| size             | Int64       | false    |               |
| start_time       | DateTime    | false    |               |
| symbol           | String      | false    |               |
| size             | Int64       | false    |               |

## Code samples:

```julia
using Serde
using CryptoExchangeAPIs.Huobi

huobi_client = CryptoExchangeAPIs.Huobi.HuobiClient(;
    base_url = "https://api.huobi.pro",
    public_key = ENV["HUOBI_PUBLIC_KEY"],
    secret_key = ENV["HUOBI_SECRET_KEY"],
)

result = Huobi.Spot.order_log(
    huobi_client;
    start_time = now(UTC) - Day(1),
    end_time = now(UTC) - Hour(1),
    size = 1000,
)

to_pretty_json(result.result)
```

## Result:

```json
{
  "status":"ok",
  "data":[
    {
      "id":345487249132375,
      "symbol":"polyusdt",
      "account-id":13496526,
      "client-order-id":"",
      "amount":50.0,
      "price":0.0,
      "created-at":"2021-02-02T10:22:10",
      "type":"buy-market",
      "field-amount":147.92899,
      "field-cash-amount":49.99999,
      "field-fees":0.29585,
      "finished-at":1629443051838,
      "source":"spot-web",
      "state":"filled",
      "canceled-at":0
    },
    ...
  ]
}
```
"""
function order_log(client::HuobiClient, query::OrderLogQuery)
    return APIsRequest{Data{Vector{OrderLogData}}}("GET", "v1/order/history", query)(client)
end

function order_log(client::HuobiClient; kw...)
    return order_log(client, OrderLogQuery(; kw...))
end

end
