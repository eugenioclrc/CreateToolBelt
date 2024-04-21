// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {compile, Vm} from "../test/DeployHelper.sol";

contract DeployScript is Script {
    using {compile} for Vm;

    function setUp() public {}

    function run() public returns (address create2Factory) {
        // Used by default when deploying with create2, https://github.com/Arachnid/deterministic-deployment-proxy.
        require(CREATE2_FACTORY.code.length > 0, "CREATE2FACTORY NOT DEPLOYED!");
        bytes memory bytecode = vm.compile("src/CREATE2FACTORY.huff");

        vm.startBroadcast();
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c93cba124c4fab5b9c54d01c0), // salt
                bytecode
            )
        );
        vm.stopBroadcast();
        require(sucess, "Failed to deploy CREATE2FACTORY");

        assembly {
            create2Factory := mload(add(response, 0x14))
        }

        require(create2Factory == 0x0000000004E9754d5589C4C3859dB89282Bedb2a, "Failed to deploy CREATE2FACTORY");
    }
}
