![terminal](assets/terminal.gif)

# CryptoExchangeAPIs.jl

CryptoExchangeAPIs is a library written in Julia that combines API wrappers from various exchanges, simplifying access to market 💹 data.

## Installation
If you haven't installed our [local registry](https://github.com/bhftbootcamp/Green) yet, do that first:
```
] registry add https://github.com/bhftbootcamp/Green.git
```

Then, to install CryptoExchangeAPIs, simply use the Julia package manager:
```
] add CryptoExchangeAPIs
```

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
                <td><img src="assets/aevo.png" alt="Aevo Logo" width="20" height="20"></td>
                <td><a href="https://www.aevo.xyz/">Aevo</a></td>
                <td><a href="https://api-docs.aevo.xyz/reference/overview">Futures</a></td>
                <td><a href="src/Aevo/Futures">CryptoExchangeAPIs.Aevo.Futures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Aevo/#Futures">Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/en/trade">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/spot/en/">Spot</a></td>
                <td><a href="src/Binance/Spot">CryptoExchangeAPIs.Binance.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Binance/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/futures">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/futures/en/#change-log">USD-M Futures</a></td>
                <td><a href="src/Binance/USDMFutures">CryptoExchangeAPIs.Binance.USDMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Binance/#USDMFutures">USD-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/binance.png" alt="Binance Logo" width="20" height="20"></td>
                <td><a href="https://www.binance.com/delivery">Binance</a></td>
                <td><a href="https://binance-docs.github.io/apidocs/delivery/en/">Coin-M Futures</a></td>
                <td><a href="src/Binance/CoinMFutures">CryptoExchangeAPIs.Binance.CoinMFutures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Binance/#CoinMFutures">Coin-M Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/bitfinex.png" alt="Bitfinex Logo" width="20" height="20"></td>
                <td><a href="https://www.bitfinex.com/">Bitfinex</a></td>
                <td><a href="https://docs.bitfinex.com/docs/introduction">Spot</a></td>
                <td><a href="src/Bitfinex/Spot">CryptoExchangeAPIs.Bitfinex.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Bitfinex/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/bithumb.png" alt="Bithumb Logo" width="20" height="20"></td>
                <td><a href="https://m.bithumb.com/">Bithumb</a></td>
                <td><a href="https://apidocs.bithumb.com/">Spot</a></td>
                <td><a href="src/Bithumb/Spot">CryptoExchangeAPIs.Bithumb.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Bithumb/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/bybit.png" alt="Bybit Logo" width="20" height="20"></td>
                <td><a href="https://www.bybit.com/en/trade/spot/BTC/USDT">Bybit</a></td>
                <td><a href="https://bybit-exchange.github.io/docs/">Spot</a></td>
                <td><a href="src/Bybit/Spot">CryptoExchangeAPIs.Bybit.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Bybit/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/coinbase.png" alt="Coinbase Logo" width="20" height="20"></td>
                <td><a href="https://www.coinbase.com/">Coinbase Exchange</a></td>
                <td><a href="https://docs.cloud.coinbase.com/exchange/reference/">Spot</a></td>
                <td><a href="src/Coinbase/Spot">CryptoExchangeAPIs.Coinbase.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Coinbase/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/cryptocom.png" alt="Cryptocom Logo" width="20" height="20"></td>
                <td><a href="https://crypto.com/">Cryptocom</a></td>
                <td><a href="https://exchange-docs.crypto.com/exchange/v1/rest-ws/index.html#introduction">Spot</a></td>
                <td><a href="src/Cryptocom/Spot">CryptoExchangeAPIs.Cryptocom.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Cryptocom/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/deribit.png" alt="Deribit Logo" width="20" height="20"></td>
                <td><a href="https://www.deribit.com/">Deribit</a></td>
                <td><a href="https://docs.deribit.com/">Common</a></td>
                <td><a href="src/Deribit/Common">CryptoExchangeAPIs.Deribit.Common</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Deribit/#Common">Common</a></td>
            </tr>
            <tr>
                <td><img src="assets/gateio.png" alt="Gateio Logo" width="20" height="20"></td>
                <td><a href="https://www.gate.io/">Gate.io</a></td>
                <td><a href="https://www.gate.io/docs/developers/apiv4/">Spot</a></td>
                <td><a href="src/Gateio/Spot">CryptoExchangeAPIs.Gateio.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Gateio/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/gateio.png" alt="Gateio Logo" width="20" height="20"></td>
                <td><a href="https://www.gate.io/">Gate.io</a></td>
                <td><a href="https://www.gate.io/docs/developers/apiv4/">Futures</a></td>
                <td><a href="src/Gateio/Futures">CryptoExchangeAPIs.Gateio.Futures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Gateio/#Futures">Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/huobi.png" alt="Huobi Logo" width="20" height="20"></td>
                <td><a href="https://www.htx.com/">Huobi</a></td>
                <td><a href="https://www.htx.com/en-us/opend/newApiPages">Spot</a></td>
                <td><a href="src/Huobi/Futures">CryptoExchangeAPIs.Huobi.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Huobi/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/kraken.png" alt="Kraken Logo" width="20" height="20"></td>
                <td><a href="https://www.kraken.com/">Kraken</a></td>
                <td><a href="https://docs.kraken.com/rest/">Spot</a></td>
                <td><a href="src/Kraken/Spot">CryptoExchangeAPIs.Kraken.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Kraken/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/kucoin.png" alt="Kucoin Logo" width="20" height="20"></td>
                <td><a href="https://www.kucoin.com/">Kucoin</a></td>
                <td><a href="https://www.kucoin.com/docs/beginners/introduction">Spot</a></td>
                <td><a href="src/Kucoin/Spot">CryptoExchangeAPIs.Kucoin.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Kucoin/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/kucoin.png" alt="Kucoin Logo" width="20" height="20"></td>
                <td><a href="https://www.kucoin.com/">Kucoin</a></td>
                <td><a href="https://www.kucoin.com/docs/beginners/introduction">Futures</a></td>
                <td><a href="src/Kucoin/Futures">CryptoExchangeAPIs.Kucoin.Futures</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Kucoin/#Futures">Futures</a></td>
            </tr>
            <tr>
                <td><img src="assets/okex.png" alt="Okex Logo" width="20" height="20"></td>
                <td><a href="https://www.okx.com/">Okex</a></td>
                <td><a href="https://www.okx.com/docs-v5/en/">Spot</a></td>
                <td><a href="src/Okex/Spot">CryptoExchangeAPIs.Okex.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Okex/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/poloniex.png" alt="Poloniex Logo" width="20" height="20"></td>
                <td><a href="https://poloniex.com/">Poloniex</a></td>
                <td><a href="https://api-docs.poloniex.com/spot">Spot</a></td>
                <td><a href="src/Poloniex/Spot">CryptoExchangeAPIs.Poloniex.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Poloniex/#Spot">Spot</a></td>
            </tr>
            <tr>
                <td><img src="assets/upbit.png" alt="Upbit Logo" width="20" height="20"></td>
                <td><a href="https://upbit.com/">Upbit</a></td>
                <td><a href="https://global-docs.upbit.com/">Spot</a></td>
                <td><a href="src/Upbit/Spot">CryptoExchangeAPIs.Upbit.Spot</a></td>
                <td><a href="https://bhftbootcamp.github.io/CryptoExchangeAPIs.jl/stable/pages/Upbit/#Spot">Spot</a></td>
            </tr>
        </table>
    </body>
</html>
```
