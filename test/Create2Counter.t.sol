// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {compile, Vm} from "./DeployHelper.sol";

// This test demonstrates how to deploy a contract using CREATE2 the huff version
contract CounterTest is Test {
    using {compile} for Vm;

    address immutable CREATE2DEPLOYER = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
    address HUFFCREATE2DEPLOYER;
    function setUp() public {
        require(CREATE2DEPLOYER.code.length > 0, "CREATE2DEPLOYER NOT DEPLOYED!");

        bytes memory bytecode = vm.compile("src/CREATE2DEPLOYER.huff");
        (bool sucess, bytes memory response) = CREATE2DEPLOYER.call(abi.encodePacked(
            bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c93cba124c4fab5b9c54d01c0), // salt
            bytecode
        ));
        assertTrue(sucess, "Failed to deploy CREATE2DEPLOYER");
        
        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }

        assertEq(deployed, 0x0000000004E9754d5589C4C3859dB89282Bedb2a, "Failed to deploy CREATE2DEPLOYER");
        HUFFCREATE2DEPLOYER = deployed;
    }

    function test_Increment() public {
        (bool sucess, bytes memory response) = HUFFCREATE2DEPLOYER.call(abi.encodePacked(
            bytes32(keccak256("salt")),
            type(Counter).creationCode)
        );
        assertTrue(sucess, "Failed to deploy Counter");
        Counter counter;
        assembly {
            counter := mload(add(response, 0x14))
        }
        counter.increment();

        assertEq(counter.number(), 1, "Counter should be 1");
    }
}
