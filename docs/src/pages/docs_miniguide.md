# Docs mini-guide

Here's a quick reference about what changes you need to make to the package description and documentation when adding new content.

## [New exchange](@id new_exchange)

When adding a new exchange to the package, you need to make the following changes:
- In the `Supported Exchange APIs` table in the README.md you need to add a new row with links to relevant resources:
```html
...
<tr>
    <td><img src="docs/src/assets/EXCHANGE_LOGO.png" alt="Exchange Logo" width="20" height="20"></td>
    <td><a href="https://EXCHANGE_LINK">EXCHANGE_NAME</a></td>
    <td><a href="https://EXCHANGE_MARKET_LINK">MARKET_TYPE</a></td>
    <td><a href="src/EXCHANGE_NAME/MARKET_TYPE">CryptoAPIs.EXCHANGE_NAME.MARKET_TYPE</a></td>
    <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/EXCHANGE_NAME/#MARKET_TYPE">MARKET_TYPE</a></td>
</tr>
...
```
- Similarly, add a new line to the table on the main documentation page in the file `docs/src/index.md` (the only difference will be the path of the logo: `<img src="assets/EXCHANGE_LOGO.png" ...>`).
```html
...
<tr>
    <td><img src="assets/EXCHANGE_LOGO.png" alt="Exchange Logo" width="20" height="20"></td>
    <td><a href="https://EXCHANGE_LINK">EXCHANGE_NAME</a></td>
    <td><a href="https://EXCHANGE_MARKET_LINK">MARKET_TYPE</a></td>
    <td><a href="src/EXCHANGE_NAME/MARKET_TYPE">CryptoAPIs.EXCHANGE_NAME.MARKET_TYPE</a></td>
    <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/EXCHANGE_NAME/#MARKET_TYPE">MARKET_TYPE</a></td>
</tr>
...
```
- Add a docstring describing key types and methods (clients, errors, etc.).
- Create a new documentation page in the `docs/src/pages/` folder in markdown format with the appropriate exchange name, for example `docs/src/pages/Binance.md`.
- The documentation page should have the following section structure:
````
# EXCHANGE_NAME

```@docs
CryptoAPIs.EXCHANGE_NAME.<...>
<!-- Here list everything that is directly related to the
general description of the exchange (clients, errors, etc.) -->
```

<!-- Sections related to exchange markets begin here -->
````

## New market

When adding a new market type for an exchange, you need to make the following changes:
- Similar to [adding a new exchange](@ref new_exchange), you need to add a new row to the table with `Supported Exchange APIs` (in the README.md and on the main page of the documentation `docs/src/index.md`) corresponding to the new type of market.
- Add a docstring describing key types and methods related to the market (public client, etc.).
- Add a new section corresponding to the exchange market in the file `docs/src/pages/EXCHANGE_NAME.md`:
````
## MARKET_TYPE

```@docs
CryptoAPIs.EXCHANGE_NAME.MARKET_TYPE.<...>
<!-- Here list everything that is related to the market (public client, etc.) -->
```

```@docs
CryptoAPIs.EXCHANGE_NAME.MARKET_TYPE.<...>
<!-- Here list the API methods for the market -->
```
````

## New API method

When adding a new API method, it is enough to add a docstring with a description of the method according to [template](@ref template).
After that, add the method to the section of the corresponding market in the documentation (in the file `docs/src/pages/EXCHANGE_NAME.md`):
````
## MARKET_TYPE

...

```@docs
CryptoAPIs.EXCHANGE_NAME.MARKET_TYPE.<...>
<!-- Here list the API methods for the market -->
```
````

### [Template for API method docs](@id template)

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

result = EXCHANGE_MODULE.SUB_MODULE.METHOD_NAME(;
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
