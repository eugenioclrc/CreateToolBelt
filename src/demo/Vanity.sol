// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// solamate libs
import {ERC721} from "./ERC721.sol";
import {CREATE3FACTORYPredict} from "../CREATE3FACTORYPredict.sol";

contract Vanity is ERC721("Vanity", "VANITY") {
    address constant CREATE3FACTORY = 0x00000000231C09b34010207Ca8F37bf1f9dBac7c;
    mapping(bytes32 commitHash => uint256 deadline) commitReveal;
    mapping(bytes12 salt => bool minted) minted;

    // commit reveal scheme, to avoid frontrun
    function reserve(bytes32 _commit) external {
        commitReveal[_commit] = block.timestamp;
    }

    function mint(address to, bytes12 _salt) external {
        require(!minted[_salt], "minted");
        bytes32 commit = keccak256(abi.encodePacked(msg.sender, _salt));
        require(
            commitReveal[commit] < block.timestamp && (commitReveal[commit] + 1 hours) > block.timestamp, "!reserved"
        );
        minted[_salt] = true;
        _mint(to, uint256(uint96(_salt)));
    }

    function deploy(uint256 id, bytes memory code) external returns (address deployed) {
        require(_ownerOf[id] == msg.sender, "!owner");
        _burn(id);

        (bool sucess, bytes memory response) = CREATE3FACTORY.call(
            abi.encodePacked(
                bytes32(
                    abi.encodePacked(
                        address(this), 
                        bytes12(uint96(id))
                    )
                ), 
                code
        ));
        require(sucess, "deploy fail");
        assembly {
            deployed := mload(add(response, 0x14))
        }
    }

    function associatedAddress(uint256 id) external view returns (address) {
        bytes12 salt = bytes12(uint96(id));
        require(minted[salt], "!exist");
        return CREATE3FACTORYPredict.getDeployed(address(this), salt);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_ownerOf[id] == address(0), "!exist");
        return ""; // for now and mainly to keep this simple there is no tokenURI
            //address predict = CREATE3FACTORYPredict.getDeployed(address(this), bytes12(bytes32(id)));
            //return string.concat("https://placehold.co/600x500?text=", bytes10(predict), "/n", bytes10(predict/10));
            //https://placehold.co/600x500?text=0x38c40EAd3D0Fe7959eb9DFE8337B3c4929884d2c
    }
}
