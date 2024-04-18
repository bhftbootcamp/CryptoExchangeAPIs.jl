# CryptoAPIs.jl

CryptoAPIs is a library written in Julia that combines API wrappers from various exchanges, simplifying access to market 💹 data.

## Supported Exchange APIs

```@raw html
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
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/en/trade">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/spot/en/">Spot</a></td>
                <td><a href="src/Binance/Spot">CryptoAPIs.Binance.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/futures">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/futures/en/#change-log">USD-M Futures</a></td>
                <td><a href="src/Binance/USDMFutures">CryptoAPIs.Binance.USDMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#USDMFutures">USD-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/delivery">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/delivery/en/">Coin-M Futures</a></td>
                <td><a href="src/Binance/CoinMFutures">CryptoAPIs.Binance.CoinMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Binance/#CoinMFutures">Coin-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/bybit.png" alt="Bybit Logo" width="20" height="20"></td>
                <td><a href="https://www.bybit.com/en/trade/spot/BTC/USDT">Bybit</a></td>
                <td><a href="https://bybit-exchange.github.io/docs/">Spot</a></td>
                <td><a href="src/Bybit/Spot">CryptoAPIs.Bybit.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Bybit/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/coinbase.png" alt="Coinbase Logo" width="20" height="20"></td>
                <td><a href="https://www.coinbase.com/">Coinbase Exchange</a></td>
                <td><a href="https://docs.cloud.coinbase.com/exchange/reference/">Spot</a></td>
                <td><a href="src/Coinbase/Spot">CryptoAPIs.Coinbase.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Coinbase/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/gateio.png" alt="Gateio Logo" width="20" height="20"></td>
                <td><a href="https://www.gate.io/">Gate.io</a></td>
                <td><a href="https://www.gate.io/docs/developers/apiv4/">Spot</a></td>
                <td><a href="src/Gateio/Spot">CryptoAPIs.Gateio.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Gateio/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/okex.png" alt="Okex Logo" width="20" height="20"></td>
                <td><a href="https://www.okx.com/">Okex</a></td>
                <td><a href="https://www.okx.com/docs-v5/en/">Spot</a></td>
                <td><a href="src/Okex/Spot">CryptoAPIs.Okex.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Okex/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/upbit.png" alt="Upbit Logo" width="20" height="20"></td>
                <td><a href="https://upbit.com/">Upbit</a></td>
                <td><a href="https://global-docs.upbit.com/">Spot</a></td>
                <td><a href="src/Upbit/Spot">CryptoAPIs.Upbit.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Upbit/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/cryptocom.png" alt="Cryptocom Logo" width="20" height="20"></td>
                <td><a href="https://crypto.com/">Cryptocom</a></td>
                <td><a href="https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#introduction">Spot</a></td>
                <td><a href="src/Cryptocom/Spot">CryptoAPIs.Cryptocom.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoAPIs.jl/stable/pages/Cryptocom/#Spot">Spot</a></td>
            </tr>
        </table>
    </body>
</html>
```

## Quickstart

```julia
using CryptoAPIs
using CryptoAPIs.Binance

Binance.Spot.ticker(;
    symbols = ["ADAUSDT", "BTCUSDT"]
)

Binance.Spot.candle(;
    symbol = "ADAUSDT",
    interval = Binance.Spot.Candle.M1
)

Binance.Spot.avg_price(;
    symbol = "ADAUSDT"
)

Binance.Spot.order_book(;
    symbol = "ADAUSDT"
)
```
