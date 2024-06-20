module Spot

using CryptoAPIs.CoinMarketCap

"""
    public_client = CoinMarketCapClient(; base_url = "https://pro-api.coinmarketcap.com")

"""
const public_client =
    CoinMarketCapClient(; base_url = "https://pro-api.coinmarketcap.com", secret_key = ENV["X_CMC_PRO_API_KEY"])

# Convert one cryptocurrency into fiat or another cryptocurrency
# /v2/tools/price-conversion
include("API/PriceConverter.jl")
using .PriceConverter

# Returns a paginated list of all active cryptocurrency exchanges by CoinMarketCap ID
# /v1/cryptocurrency/map
include("API/IDMap.jl")
using .IDMap

# Returns a mapping of all supported fiat currencies to unique CoinMarketCap ids
# /v1/fiat/map
include("API/FiatMap.jl")
using .FiatMap

# Returns all static metadata available for one or more cryptocurrencies.
# /v2/cryptocurrency/info
include("API/CcyInfo.jl")
using .CcyInfo

# Returns information about all coin categories available on CoinMarketCap.
# /v1/cryptocurrency/categories
include("API/CoinCategories.jl")
using .CoinCategories

# Returns all static metadata for one or more exchanges.
# /v1/exchange/info
include("API/ExcInfo.jl")
using. ExcInfo

# Returns the exchange assets in the form of token holdings.
# /v1/exchange/assets
include("API/ExcAssets.jl")
using .ExcAssets

# Returns the latest global cryptocurrency market metrics.
# /v1/global-metrics/quotes/latest
include("API/QuotesLatest.jl")
using .QuotesLatest

end
