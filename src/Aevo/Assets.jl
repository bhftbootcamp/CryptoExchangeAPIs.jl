module Assets

export AssetsQuery, assets

using CryptoExchangeAPIs.Aevo
using CryptoExchangeAPIs: Maybe, APIsRequest

struct AssetsQuery <: AevoPublicQuery end

"""
    assets(client::AevoClient, query::AssetsQuery)
    assets(client::AevoClient = Aevo.AevoClient(Aevo.public_config); kw...)

Returns the list of assets.

[`GET assets`](https://api-docs.aevo.xyz/reference/getassets)

## Code samples:

```julia
using CryptoExchangeAPIs.Aevo

result = Aevo.assets()
```
"""
function assets(client::AevoClient, query::AssetsQuery)
    return APIsRequest{Vector{String}}("GET", "assets", query)(client)
end

function assets(client::AevoClient = Aevo.AevoClient(Aevo.public_config))
    return assets(client, AssetsQuery())
end

end