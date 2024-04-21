<p align="center">
  <img src="./logo2.png" width="128" title="Logo">
</p>

# CreateToolBelt

Welcome to CreateToolBelt, an innovative suite of smart contract deployment tools designed for the Ethereum blockchain. CreateToolBelt leverages enhanced versions of the CREATE2 and CREATE3 deployment methods, ensuring deterministic deployments across multiple blockchains with added security against front-running.

## Features

- **CREATE2Factory**: A remake of the [CREATE2FACTORY](https://github.com/Arachnid/deterministic-deployment-proxy) but with a few micro optimizations and rewrite in Huff.
- **CREATE2SafeFactory**: Builds on the security features of CREATE2Factory by addressing specific vulnerabilities associated with frontrunning issues on CREATE2 deployments rewrite in Huff.
- **Create3Factory**: Allows for the consistent deployment of contracts across multiple blockchains using the same address, utilizing both CREATE2 and CREATE deployment methods. This deployer ensures that the final contract address is consistent, regardless of the blockchain network, by using a fixed deployer address and a deterministic salt rewrite in Huff.

All this contracts are prepared to be deployed using the Arachnid CREATE2FACTORY on [0x4e59b44847b379578588920ca78fbf26c0b4956c](https://etherscan.io/address/0x4e59b44847b379578588920ca78fbf26c0b4956c)


### Installation

Clone the repository and install the dependencies:

```bash
git clone https://github.com/yourusername/CreateToolBelt.git
cd CreateToolBelt
```
### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy

```shell
$ forge script script/Create2Factory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Create2SafeFactory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Create3Factory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

> Contract final deployed address of all contracts should be always the same.