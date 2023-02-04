// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import "../Map.sol";

contract MockMap is Map {
    constructor(
        string memory _name,
        string memory _baseURI,
        uint16 _numberOfTiles
    ) Map(_name, _baseURI, _numberOfTiles) {}

    function detectLocation(uint256 lat, uint256 lng)
        public
        view
        returns (uint256)
    {
        return _detectLocation(_toCoordinates(lat, lng));
    }

    function move(
        address account,
        uint256 lat,
        uint256 lng
    ) public {
        _move(account, lat, lng);
    }
}
