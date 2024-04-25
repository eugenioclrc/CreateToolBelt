// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

library CREATE3FACTORYPredict {
    bytes32 constant PROXY_BYTECODE_HASH = 0xbb908235335e3d6acecf544d682abde3fae769324b91ff66eae03c7c0fc2a952;

    function getDeployed(address deployer, bytes12 salt) internal pure returns (address) {
        address proxy = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            // Prefix:
                            bytes1(0xFF),
                            // crate3factory: should be 0x00000000231C09b34010207Ca8F37bf1f9dBac7c
                            0x00000000231C09b34010207Ca8F37bf1f9dBac7c,
                            // Salt:
                            bytes32(abi.encodePacked(deployer, salt)),
                            // Bytecode hash:
                            PROXY_BYTECODE_HASH
                        )
                    )
                )
            )
        );

        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            // 0xd6 = 0xc0 (short RLP prefix) + 0x16 (length of: 0x94 ++ proxy ++ 0x01)
                            // 0x94 = 0x80 + 0x14 (0x14 = the length of an address, 20 bytes, in hex)
                            hex"d694",
                            proxy,
                            hex"01" // Nonce of the proxy contract (1)
                        )
                    )
                )
            )
        );
    }
}
