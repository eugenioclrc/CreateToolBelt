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

        bytes memory bytecode = vm.compile("src/CREATE2SAFEDEPLOYER.huff");
        (bool sucess, bytes memory response) = CREATE2DEPLOYER.call(
            abi.encodePacked(
                bytes32(0xdd6e37e0620a60f41055331e8d0d92956e44eeba56d3192dfd65e1aa1b91f6c5), // salt
                bytecode
            )
        );
        assertTrue(sucess, "Failed to deploy CREATE2DEPLOYER");

        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }

        assertEq(deployed, 0x00000008C8F9e0892092947ccc041897e8633523, "Failed to deploy CREATE2DEPLOYER");
        HUFFCREATE2DEPLOYER = deployed;
    }

    function test_deployCreate2(uint256 start) public {
        start = bound(start, 0, type(uint256).max - 1);

        // @dev note that the bytecode cant be frontrunned
        (bool sucess, bytes memory response) = HUFFCREATE2DEPLOYER.call(
            abi.encodePacked(bytes32(keccak256("salt")), abi.encodePacked(type(Counter).creationCode), start)
        );
        assertFalse(sucess, "show return false due missing frontrun protection");

        (sucess, response) = HUFFCREATE2DEPLOYER.call(
            abi.encodePacked(
                bytes32(abi.encodePacked(address(this), bytes12(keccak256("salt")))),
                abi.encodePacked(type(Counter).creationCode),
                start
            )
        );

        Counter counter;
        assembly {
            counter := mload(add(response, 0x14))
        }
        assertEq(counter.number(), start, "Counter should be start number");
        counter.increment();
        assertEq(counter.number(), start + 1, "Counter should be start number + 1");
    }
}
