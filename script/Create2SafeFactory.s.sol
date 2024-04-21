// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {compile, Vm} from "../test/DeployHelper.sol";

contract DeployScript is Script {
    using {compile} for Vm;

    function setUp() public {}

    function run() public returns (address create2Factory) {
        // Used by default when deploying with create2, https://github.com/Arachnid/deterministic-deployment-proxy.
        require(CREATE2_FACTORY.code.length > 0, "CREATE2SAFEFACTORY NOT DEPLOYED!");
        bytes memory bytecode = vm.compile("src/CREATE2SAFEFACTORY.huff");

        vm.startBroadcast();
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0xdd6e37e0620a60f41055331e8d0d92956e44eeba56d3192dfd65e1aa1b91f6c5), // salt
                bytecode
            )
        );
        vm.stopBroadcast();
        require(sucess, "Failed to deploy CREATE2SAFEFACTORY");

        assembly {
            create2Factory := mload(add(response, 0x14))
        }

        require(create2Factory == 0x00000008C8F9e0892092947ccc041897e8633523, "Failed to deploy CREATE2SAFEFACTORY");
    }
}
