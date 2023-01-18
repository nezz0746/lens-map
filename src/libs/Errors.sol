// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

library Errors {
    error invalidNumberOfTiles();
    error accountNotSender();
    error movingToSameLocation();
    error nonTransferable();
    error notInLocation();
    error notProfileOwner();
}
