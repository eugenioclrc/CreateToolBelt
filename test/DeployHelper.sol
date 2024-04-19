// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Vm} from "forge-std/Vm.sol";

function compile(Vm vm, string memory source) returns (bytes memory) {
    string[] memory cmd = new string[](5);
    cmd[0] = "huffc";
    cmd[1] = "-e";
    cmd[2] = "paris";
    cmd[3] = "--bytecode";
    cmd[4] = source;

    return vm.ffi(cmd);
}
