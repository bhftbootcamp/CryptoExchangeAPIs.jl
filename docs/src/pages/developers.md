# For Developers

## Template for API method docs

````julia
"""
    METHOD_NAME(client::EXCHANGE_CLIENT, query::METHOD_QUERY)
    METHOD_NAME(client::EXCHANGE_CLIENT = EXCHANGE_MODULE.SUB_MODULE.public_client; kw...)

DESCRIPTION.

[`GET HTTP_REQUEST`](METHOD_URL)

## Parameters:

| Parameter | Type     | Required | Description |
|:----------|:---------|:---------|:------------|
| name      | type     | bool     | description |

## Code samples:

```julia
using Serde
using CryptoAPIs.EXCHANGE_MODULE

result = EXCHANGE_MODULE.SUB_MODULE.METHOD_MODULE.METHOD_NAME(;
    ...
)

to_pretty_json(result.result)
```

## Result:

```json
{
    JSON_RESULT
}
```
"""
````
