// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./utils/DSTestFull.sol";
import "../src/Map.sol";
import "../src/mocks/MockMap.sol";

contract BaseMapTest is DSTestFull {
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

contract Unit_MapTest_LocationEncoding is BaseMapTest {
    MockMap mockMap;
    uint256 MAX_INT = 2**256 - 1;

    function setUp() public override {
        mockMap = new MockMap("Test Map", "ipfs://[CID]", 1000);
    }

    function testMaxLat(uint256 lat, uint256 lng) public {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat > 180 * multiplicator);
        vm.assume(lng <= 360 * multiplicator);

        vm.expectRevert(Errors.invalidCoordinates.selector);
        mockMap.detectLocation(lat, lng);
    }

    function testMaxLng(uint256 lat, uint256 lng) public {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat <= 180 * multiplicator);
        vm.assume(lng > 360 * multiplicator);

        vm.expectRevert(Errors.invalidCoordinates.selector);
        mockMap.detectLocation(lat, lng);
    }

    function testDetectLocation(uint256 lat, uint256 lng) public view {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat <= 180 * multiplicator);
        vm.assume(lng <= 360 * multiplicator);

        mockMap.detectLocation(lat, lng);
    }
}

contract Unit_MapTest_Move is BaseMapTest {
    MockMap mockMap;
    uint256 MAX_INT = 2**256 - 1;

    function setUp() public override {
        mockMap = new MockMap("Test Map", "ipfs://[CID]", 1000);
    }

    function testMove(uint256 lat, uint256 lng) public {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat <= 180 * multiplicator);
        vm.assume(lng <= 360 * multiplicator);

        address account = label("account");

        prankAs(account);
        mockMap.move(account, lat, lng);

        assertEq(
            mockMap.getUserLocation(account),
            mockMap.detectLocation(lat, lng)
        );
    }

    function testCannotMoveToSameLocation(uint256 lat, uint256 lng) public {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat <= 180 * multiplicator);
        vm.assume(lng <= 360 * multiplicator);

        address account = label("account");

        prankAs(account);
        mockMap.move(account, lat, lng);

        prankAs(account);
        vm.expectRevert(Errors.movingToSameLocation.selector);
        mockMap.move(account, lat, lng);
    }
}

contract Unit_MapTest_Transferability is BaseMapTest {
    MockMap mockMap;
    uint256 MAX_INT = 2**256 - 1;

    function setUp() public override {
        mockMap = new MockMap("Test Map", "ipfs://[CID]", 1000);
    }

    function testCannotTransferLocation(uint256 lat, uint256 lng) public {
        (, , uint16 multiplicator) = mockMap.getConfiguration();

        vm.assume(lat <= 180 * multiplicator);
        vm.assume(lng <= 360 * multiplicator);

        address account = label("account");
        address account2 = label("account2");

        prankAs(account);
        mockMap.move(account, lat, lng);

        uint256 accountLocation = mockMap.getUserLocation(account);

        prankAs(account);
        vm.expectRevert(Errors.nonTransferable.selector);
        mockMap.safeTransferFrom(account, account2, accountLocation, 1, "");
    }
}
