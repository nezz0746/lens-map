// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Map.sol";

// Example of a custom map contract
contract MyMap is Map {
    constructor() Map("MyMap", "ipfs://[CID]", 1000) {}

    // Basic public move function implementation
    function move(
        address account,
        uint256 lat,
        uint256 lng
    ) public payable {
        _move(account, lat, lng);
    }
}
