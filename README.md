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

Deploy all contracts:
```shell
$forge script script/DeployAll.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

Or deploy as you need:
```shell
$ forge script script/Create2Factory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Create2SafeFactory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
$ forge script script/Create3Factory.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

> Contract final deployed address of all contracts should be always the same.

### Deployments Mainnet

#### Arbitrum
- Create2Factory: [0x0000000004E9754d5589C4C3859dB89282Bedb2a](https://arbiscan.io/address/0x0000000004E9754d5589C4C3859dB89282Bedb2a)
- Create2SafeFactory: [0x00000008C8F9e0892092947ccc041897e8633523](https://arbiscan.io/address/0x00000008C8F9e0892092947ccc041897e8633523)
- Create3Factory: [0x00000000231C09b34010207Ca8F37bf1f9dBac7c](https://arbiscan.io/address/0x00000000231C09b34010207Ca8F37bf1f9dBac7c)

#### Ethereum
- Create2Factory: [0x0000000004E9754d5589C4C3859dB89282Bedb2a](https://etherscan.io/address/0x0000000004E9754d5589C4C3859dB89282Bedb2a)
- Create2SafeFactory: [0x00000008C8F9e0892092947ccc041897e8633523](https://etherscan.io/address/0x00000008C8F9e0892092947ccc041897e8633523)
- Create3Factory: [0x00000000231C09b34010207Ca8F37bf1f9dBac7c](https://etherscan.io/address/0x00000000231C09b34010207Ca8F37bf1f9dBac7c)

#### BSC
- Create2Factory: [0x0000000004E9754d5589C4C3859dB89282Bedb2a](https://bscscan.com/address/0x0000000004E9754d5589C4C3859dB89282Bedb2a)
- Create2SafeFactory: [0x00000008C8F9e0892092947ccc041897e8633523](https://bscscan.com/address/0x00000008C8F9e0892092947ccc041897e8633523)
- Create3Factory: [0x00000000231C09b34010207Ca8F37bf1f9dBac7c](https://bscscan.com/address/0x00000000231C09b34010207Ca8F37bf1f9dBac7c)

#### Polygon
- Create2Factory: [0x0000000004E9754d5589C4C3859dB89282Bedb2a](https://polygonscan.com/address/0x0000000004E9754d5589C4C3859dB89282Bedb2a)
- Create2SafeFactory: [0x00000008C8F9e0892092947ccc041897e8633523](https://polygonscan.com/address/0x00000008C8F9e0892092947ccc041897e8633523)
- Create3Factory: [0x00000000231C09b34010207Ca8F37bf1f9dBac7c](https://polygonscan.com/address/0x00000000231C09b34010207Ca8F37bf1f9dBac7c)


### Deployments Testnet

#### Sepolia
- Create2Factory: [0x0000000004E9754d5589C4C3859dB89282Bedb2a](https://sepolia.etherscan.io/address/0x0000000004E9754d5589C4C3859dB89282Bedb2a)
- Create2SafeFactory: [0x00000008C8F9e0892092947ccc041897e8633523](https://sepolia.etherscan.io/address/0x00000008C8F9e0892092947ccc041897e8633523)
- Create3Factory: [0x00000000231C09b34010207Ca8F37bf1f9dBac7c](https://sepolia.etherscan.io/address/0x00000000231C09b34010207Ca8F37bf1f9dBac7c)
