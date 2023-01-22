// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/Map.sol";
import "../src/examples/MyMap.sol";
import "../src/MapFollowModule.sol";
import "../src/MapCollectModule.sol";

// This script will deploy your map contract with the follow & collect modules
// and whitelist them on the LensHub contract (Mumbai Sandbox)
contract DeployMapExample is Script {
    function run() public {
        vm.startBroadcast();
        address lensHubProxy = 0x7582177F9E536aB0b6c721e11f383C326F2Ad1D5;
        address mockSanboxGovernance = 0x1677d9cC4861f1C85ac7009d5F06f49c928CA2AD;

        MyMap map = new MyMap();

        // Deploy module
        MyMapFollowModule follow_module = new MapFollowModule(lensHubProxy);

        MyMapCollectModule collect_module = new MapCollectModule(lensHubProxy);

        // Whitelist module on LensHub
        ILensHub(mockSanboxGovernance).whitelistFollowModule(
            address(follow_module),
            true
        );
        ILensHub(mockSanboxGovernance).whitelistCollectModule(
            address(collect_module),
            true
        );

        vm.stopBroadcast();
    }
}
