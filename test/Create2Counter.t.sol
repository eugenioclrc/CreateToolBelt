// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {compile, Vm} from "./DeployHelper.sol";

// This test demonstrates how to deploy a contract using CREATE2 the huff version
contract CounterTest is Test {
    using {compile} for Vm;

    address HUFFCREATE2FACTORY;

    function setUp() public {
        bytes memory bytecode = vm.compile("src/CREATE2FACTORY.huff");
        // CREATE2_FACTORY create2 contract from https://github.com/Arachnid/deterministic-deployment-proxy.
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c93cba124c4fab5b9c54d01c0), // salt
                bytecode
            )
        );
        assertTrue(sucess, "Failed to deploy CREATE2FACTORY");

        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }

        assertEq(deployed, 0x0000000004E9754d5589C4C3859dB89282Bedb2a, "Failed to deploy CREATE2FACTORY");
        HUFFCREATE2FACTORY = deployed;
    }

    function test_deployCreate2Counter(uint256 start) public {
        start = bound(start, 0, type(uint256).max - 1);

        // @dev note that the bytecode could be frontrunned, if you got a `tx.origin` in the constructor could be troubles

        (bool sucess, bytes memory response) = HUFFCREATE2FACTORY.call(
            abi.encodePacked(bytes32(keccak256("salt")), abi.encodePacked(type(Counter).creationCode), start)
        );
        assertTrue(sucess, "Failed to deploy Counter");

        // @dev note that the bytecode is always different due the start param at constructor, therefore the deployed address is always different

        Counter counter;
        assembly {
            counter := mload(add(response, 0x14))
        }
        assertEq(counter.number(), start, "Counter should be start number");
        counter.increment();
        assertEq(counter.number(), start + 1, "Counter should be start number + 1");
    }
}
