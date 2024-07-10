using CryptoAPIs
using Documenter

DocMeta.setdocmeta!(CryptoAPIs, :DocTestSetup, :(using CryptoAPIs); recursive = true)

makedocs(;
    modules = [CryptoAPIs],
    sitename = "CryptoAPIs.jl",
    format = Documenter.HTML(;
        repolink = "https://github.com/bhftbootcamp/CryptoAPIs.jl",
        canonical = "https://bhftbootcamp.github.io/CryptoAPIs.jl",
        edit_link = "master",
        assets = String["assets/favicon.ico"],
        sidebar_sitename = true,
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "pages/api_reference.md",
        "pages/Aevo.md"
        "pages/Binance.md",
        "pages/Bitfinex.md",
        "pages/Bithumb.md",
        "pages/Bybit.md",
        "pages/Coinbase.md",
        "pages/Cryptocom.md",
        "pages/Deribit.md",
        "pages/Gateio.md",
        "pages/Huobi.md",
        "pages/Kraken.md",
        "pages/Kucoin.md",
        "pages/Okex.md",
        "pages/Poloniex.md",
        "pages/Upbit.md",
        "For Developers" => [
            "pages/docs_miniguide.md",
        ],
    ],
    warnonly = [:doctest, :missing_docs],
)

deploydocs(;
    repo = "github.com/bhftbootcamp/CryptoAPIs.jl",
    devbranch = "master",
    push_preview = true,
)
