// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {compile, Vm} from "../test/DeployHelper.sol";

contract DeployScript is Script {
    using {compile} for Vm;

    function setUp() public {}

    function run() public returns (address create3Factory) {
        // Used by default when deploying with create2, https://github.com/Arachnid/deterministic-deployment-proxy.
        require(CREATE2_FACTORY.code.length > 0, "CREATE2FACTORY NOT DEPLOYED!");
        bytes memory bytecode = vm.compile("src/CREATE3FACTORY.huff");

        vm.startBroadcast();
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c591861feef4bd658ae380080), // salt
                bytecode
            )
        );
        vm.stopBroadcast();
        require(sucess, "Failed to deploy CREATE2FACTORY");

        assembly {
            create3Factory := mload(add(response, 0x14))
        }

        require(create3Factory == 0x00000000231C09b34010207Ca8F37bf1f9dBac7c, "Failed to deploy CREATE3FACTORY");
    }
}
