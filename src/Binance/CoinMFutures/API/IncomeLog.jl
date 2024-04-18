module IncomeLog

export IncomeLogQuery,
    IncomeLogData,
    income_log

using Serde
using Dates, NanoDates, TimeZones

using CryptoAPIs.Binance
using CryptoAPIs: Maybe, APIsRequest

Base.@kwdef mutable struct IncomeLogQuery <: BinancePrivateQuery
    symbol::Maybe{String} = nothing
    incomeType::Maybe{String} = nothing
    startTime::Maybe{DateTime} = nothing
    endTime::Maybe{DateTime} = nothing
    limit::Maybe{Int64} = nothing

    recvWindow::Maybe{Int64} = nothing
    timestamp::Maybe{DateTime} = nothing
    signature::Maybe{String} = nothing
end

struct IncomeLogData <: BinanceData
    symbol::Maybe{String}
    incomeType::String
    info::Maybe{String}
    income::Float64
    asset::String
    time::NanoDate
    tranId::Int64
    tradeId::Maybe{String}
end

function Serde.isempty(::Type{IncomeLogData}, x)::Bool
    return x === ""
end

"""
    income_log(client::BinanceClient, query::IncomeLogQuery)
    income_log(client::BinanceClient; kw...)

[`GET dapi/v1/income`](https://binance-docs.github.io/apidocs/delivery/en/#get-income-history-user_data)

## Parameters:

| Parameter  | Type     | Required | Description |
|:-----------|:---------|:---------|:------------|
| symbol     | String   | false    |             |
| incomeType | String   | false    |             |
| startTime  | DateTime | false    |             |
| endTime    | DateTime | false    |             |
| limit      | Int64    | false    |             |
| recvWindow | Int64    | false    |             |
| timestamp  | DateTime | false    |             |
| signature  | String   | false    |             |

## Code samples:

```julia
using Serde
using CryptoAPIs.Binance

binance_client = BinanceClient(;
    base_url = "https://dapi.binance.com",
    public_key = ENV["BINANCE_PUBLIC_KEY"],
    secret_key = ENV["BINANCE_SECRET_KEY"],
)

result = Binance.CoinMFutures.income_log(
    binance_client
)

to_pretty_json(result.result)
```

## Result:

```json
[
  {
    "symbol":"ETHUSD_PERP",
    "incomeType":"FUNDING_FEE",
    "info":null,
    "income":1.2e-7,
    "asset":"ETH",
    "time":"2023-09-04T08:00:00",
    "tranId":84092344523696865420,
    "tradeId":null
  },
  ...
]
```
"""
function income_log(client::BinanceClient, query::IncomeLogQuery)
    return APIsRequest{Vector{IncomeLogData}}("GET", "dapi/v1/income", query)(client)
end

function income_log(client::BinanceClient; kw...)
    return income_log(client, IncomeLogQuery(; kw...))
end

end
