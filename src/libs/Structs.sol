// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

struct Coordinate {
    uint16 lat;
    uint16 lng;
}

struct MapFollowConfig {
    address mapAddress;
    address followingAddress;
}

struct MapCollectConfig {
    address mapAddress;
    uint256 locationId;
}
