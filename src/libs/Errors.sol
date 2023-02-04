// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

library Errors {
    error invalidNumberOfTiles();
    error invalidCoordinates();
    error accountNotSender();
    error movingToSameLocation();
    error nonTransferable();
    error notInLocation();
    error notProfileOwner();
}
