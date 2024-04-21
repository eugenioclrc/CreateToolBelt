// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {compile, Vm} from "../test/DeployHelper.sol";

contract DeployScript is Script {
    using {compile} for Vm;

    function setUp() public {}

    function deployCreate(bytes32 salt, bytes memory bytecode, address expected) internal {
        vm.startBroadcast();
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(abi.encodePacked(salt, bytecode));
        vm.stopBroadcast();
        require(sucess, "Failed to deploy");

        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }

        require(deployed == expected, "wrong address");
    }

    function run() public returns (address create2Factory, address create2SafeFactory, address create3Factory) {
        // Used by default when deploying with create2, https://github.com/Arachnid/deterministic-deployment-proxy.
        require(CREATE2_FACTORY.code.length > 0, "CREATE2FACTORY NOT DEPLOYED!");
        bytes memory bytecode = vm.compile("src/CREATE2FACTORY.huff");

        create2Factory = 0x0000000004E9754d5589C4C3859dB89282Bedb2a;
        deployCreate(
            bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c93cba124c4fab5b9c54d01c0), bytecode, create2Factory
        );

        bytecode = vm.compile("src/CREATE2SAFEFACTORY.huff");
        create2SafeFactory = 0x00000008C8F9e0892092947ccc041897e8633523;
        deployCreate(
            bytes32(0xdd6e37e0620a60f41055331e8d0d92956e44eeba56d3192dfd65e1aa1b91f6c5), bytecode, create2SafeFactory
        );

        bytecode = vm.compile("src/CREATE3FACTORY.huff");
        create3Factory = 0x0000000076D42B9563E28685aE3A7eB304ebD20c;
        deployCreate(
            bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c0aff5470784fa47dae490020), bytecode, create3Factory
        );
    }
}
