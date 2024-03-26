![terminal](docs/src/assets/terminal.gif)

# CryptoAPIs.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bhftbootcamp.github.io/CryptoAPIs.jl/dev/)
[![Build Status](https://github.com/bhftbootcamp/CryptoAPIs.jl/actions/workflows/Coverage.yml/badge.svg?branch=master)](https://github.com/bhftbootcamp/CryptoAPIs.jl/actions/workflows/Coverage.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/bhftbootcamp/CryptoAPIs.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bhftbootcamp/CryptoAPIs.jl)
[![Registry](https://img.shields.io/badge/registry-Green-green)](https://github.com/bhftbootcamp/Green)

CryptoAPIs is a library written in Julia that combines API wrappers from various exchanges, simplifying access to market 💹 data.

## Installation
If you haven't installed our [local registry](https://github.com/bhftbootcamp/Green) yet, do that first:
```
] registry add https://github.com/bhftbootcamp/Green.git
```

Then, to install CryptoAPIs, simply use the Julia package manager:
```
] add CryptoAPIs
```

## Supported Exchange APIs

<html>
    <body>
        <table>
            <tr>
                <th>#</th>
                <th>Exchange</th>
                <th>API Documentation</th>
                <th>Module</th>
                <th>Documentation</th>
            </tr>
            <tr>
                <td><img src="docs/src/assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/en/trade">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/spot/en/">Spot</a></td>
                <td><a href="src/Binance/Spot">CryptoAPIs.Binance.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="docs/src/assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/futures">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/futures/en/#change-log">USD-M Futures</a></td>
                <td><a href="src/Binance/USDMFutures">CryptoAPIs.Binance.USDMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#USDMFutures">USD-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="docs/src/assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/delivery">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/delivery/en/">Coin-M Futures</a></td>
                <td><a href="src/Binance/CoinMFutures">CryptoAPIs.Binance.CoinMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#CoinMFutures">Coin-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="docs/src/assets/coinbase.png" alt="Coinbase Logo" width="20" height="20"></td>
                <td><a href="https://www.coinbase.com/">Coinbase Exchange</a></td>
                <td><a href="https://docs.cloud.coinbase.com/exchange/reference/">Spot</a></td>
                <td><a href="src/Coinbase/Spot">CryptoAPIs.Coinbase.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Coinbase/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="docs/src/assets/upbit.png" alt="Upbit Logo" width="20" height="20"></td>
                <td><a href="https://upbit.com/">Upbit</a></td>
                <td><a href="https://global-docs.upbit.com/">Spot</a></td>
                <td><a href="src/Upbit/Spot">CryptoAPIs.Upbit.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Upbit/#Spot">Spot</a></td>
            </tr>
        </table>
    </body>
</html>

## Contributing

Contributions to CryptoAPIs are welcome! If you encounter a bug, have a feature request, or would like to contribute code, please open an issue or a pull request on GitHub.
