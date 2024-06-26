// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {compile, Vm} from "./DeployHelper.sol";
import {CREATE3FACTORYPredict} from "../src/CREATE3FACTORYPredict.sol";

// This test demonstrates how to deploy a contract using CREATE2 the huff version
contract Create3FactoryTest is Test {
    using {compile} for Vm;

    address CREATE3FACTORY;

    function setUp() public {
        bytes memory bytecode = vm.compile("src/CREATE3FACTORY.huff");
        // CREATE2_FACTORY create2 contract from https://github.com/Arachnid/deterministic-deployment-proxy.
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c591861feef4bd658ae380080), // salt
                bytecode
            )
        );
        assertTrue(sucess, "Failed to deploy CREATE3FACTORY");

        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }
        assertEq(deployed, 0x00000000231C09b34010207Ca8F37bf1f9dBac7c, "Failed to deploy CREATE3FACTORY");

        CREATE3FACTORY = deployed;
    }

    function test_deployCreate3Counter(uint256 start) public {
        start = bound(start, 0, type(uint256).max - 1);

        (bool sucess, bytes memory response) =
            CREATE3FACTORY.call(abi.encodePacked(bytes32(keccak256("salt")), type(Counter).creationCode, start));
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

        address EXPECTED_ADDRESS = CREATE3FACTORYPredict.getDeployed(address(this), bytes12(keccak256("salt")));
        assertEq(address(counter), EXPECTED_ADDRESS, "Counter should always be deployed at the expected address");

        assertEq(counter.number(), start, "Counter should be start number");
        counter.increment();
        assertEq(counter.number(), start + 1, "Counter should be start number + 1");
    }
}
