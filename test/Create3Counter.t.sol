// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {compile, Vm} from "./DeployHelper.sol";

// This test demonstrates how to deploy a contract using CREATE2 the huff version
contract CounterTest is Test {
    using {compile} for Vm;

    address CREATE3FACTORY;

    function setUp() public {
        bytes memory bytecode = vm.compile("src/CREATE3FACTORY.huff");
        // CREATE2_FACTORY create2 contract from https://github.com/Arachnid/deterministic-deployment-proxy.
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0xdd6e37e0620a60f41055331e8d0d92956e44eeba56d3192dfd65e1aa1b91f6c5), // salt
                bytecode
            )
        );
        assertTrue(sucess, "Failed to deploy CREATE2FACTORY");

        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }

        //        assertEq(deployed, 0x00000008C8F9e0892092947ccc041897e8633523, "Failed to deploy CREATE2FACTORY");
        CREATE3FACTORY = deployed;
    }

    function test_deployCreate3Counter(uint256 start) public {
        start = bound(start, 0, type(uint256).max - 1);

        (bool sucess, bytes memory response) =
            CREATE3FACTORY.call(abi.encodePacked(bytes32(keccak256("salt")), type(Counter).creationCode));
        assertFalse(sucess, "show return false due missing frontrun protection");

        (sucess, response) = CREATE3FACTORY.call(
            abi.encodePacked(
                bytes32(abi.encodePacked(address(this), bytes12(keccak256("salt")))),
                type(Counter).creationCode,
                start // note that creation code is always different due the start param at constructor
            )
        );

        assertTrue(sucess, "counter3 show be deployed");

        // @dev note that the bytecode is always different due the start param at constructor, but deployed address is always differentthe same

        Counter counter;
        assembly {
            counter := mload(add(response, 0x14))
        }

        address EXPECTED_ADDRESS = 0x5b8CD59A376CE6ca1dc7744D66cf35e4b23f9533;
        assertEq(address(counter), EXPECTED_ADDRESS, "Counter should always be deployed at the expected address");

        assertEq(counter.number(), start, "Counter should be start number");
        counter.increment();
        assertEq(counter.number(), start + 1, "Counter should be start number + 1");
    }
}
