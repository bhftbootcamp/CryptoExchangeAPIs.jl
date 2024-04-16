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
        "pages/Binance.md",
        "pages/Bybit.md",
        "pages/Coinbase.md",
        "pages/Gateio.md",
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
