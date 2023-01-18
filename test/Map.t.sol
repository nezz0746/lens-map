// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Map.sol";

contract BaseMapTest is Test {
    Map baseMap;

    constructor() {}

    function setUp() public virtual {
        baseMap = new Map("Test Map", "ipfs://[CID]", 1000);
    }
}

contract Unit_MapTest_Constructor is BaseMapTest {
    function testMapConstructor(uint16 numberOfTiles) public {
        vm.assume(numberOfTiles > 0);
        string memory name = "Test Map";
        string memory baseURI = "ipfs://[CID]";
        Map testMap = new Map(name, baseURI, numberOfTiles);
        assertEq(testMap.name(), name);
        assertEq(testMap.uri(0), baseURI);

        (uint16 latStep, uint16 lngStep, uint16 multiplicator) = testMap
            .getConfiguration();

        assertEq(latStep, (180 * multiplicator) / numberOfTiles);
        assertEq(lngStep, 2 * latStep);
    }

    function testInvalidNumberOfTiles() public {
        string memory name = "Test Map";
        string memory baseURI = "ipfs://[CID]";
        vm.expectRevert(Errors.invalidNumberOfTiles.selector);
        new Map(name, baseURI, 0);
    }
}
