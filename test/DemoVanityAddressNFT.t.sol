// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vanity} from "../src/demo/Vanity.sol";
import {compile, Vm} from "./DeployHelper.sol";
import {CREATE3FACTORYPredict} from "../src/CREATE3FACTORYPredict.sol";
import {Counter} from "../src/Counter.sol";

// This test demonstrates how to deploy a contract using CREATE2 the huff version
contract Create3FactoryTest is Test {
    using {compile} for Vm;

    address CREATE3FACTORY;

    Vanity vanity;

    function setUp() public {
        bytes memory bytecode = vm.compile("src/CREATE3FACTORY.huff");
        // CREATE2_FACTORY create2 contract from https://github.com/Arachnid/deterministic-deployment-proxy.
        (bool sucess, bytes memory response) = CREATE2_FACTORY.call(
            abi.encodePacked(
                bytes32(0x4e59b44847b379578588920ca78fbf26c0b4956c591861feef4bd658ae380080), // salt
                bytecode
            )
        );
        address deployed;
        assembly {
            deployed := mload(add(response, 0x14))
        }
        assertEq(deployed, 0x00000000231C09b34010207Ca8F37bf1f9dBac7c, "Failed to deploy CREATE3FACTORY");

        CREATE3FACTORY = deployed;

        CREATE3FACTORY.call(
            abi.encodePacked(abi.encodePacked(address(this), bytes12(keccak256("salt"))), type(Vanity).creationCode)
        );

        vanity = Vanity(CREATE3FACTORYPredict.getDeployed(address(this), bytes12(keccak256("salt"))));
    }

    function test_mint() public {
        vm.warp(1);

        bytes12 salt = bytes12(keccak256("secretSalt"));
        vanity.reserve(keccak256(abi.encodePacked(address(this), salt)));

        vm.expectRevert();
        vanity.mint(address(this), salt);

        vm.warp(block.timestamp + 1);
        vanity.mint(address(this), salt);

        vm.expectRevert();
        vanity.mint(address(this), salt);

        vanity.deploy(uint256(bytes32(salt)), abi.encodePacked(type(Counter).creationCode, uint256(0xff)));

        Counter counter = Counter(CREATE3FACTORYPredict.getDeployed(address(vanity), salt));

        assertEq(counter.number(), 0xff, "Counter should be start number");
    }
}
