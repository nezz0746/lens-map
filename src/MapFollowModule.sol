// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ModuleBase} from "@lens/core/modules/ModuleBase.sol";
import {FollowValidatorFollowModuleBase} from "@lens/core/modules/follow/FollowValidatorFollowModuleBase.sol";
import {IFollowModule} from "@lens/interfaces/IFollowModule.sol";
import {Errors} from "./libs/Errors.sol";
import "./libs/Structs.sol";

/**
 * @title MapFollowModule
 * @author nezzar.eth
 * @dev Allows certain Lens profiles to follow other profiles based on
 * their location on the map.
 */
contract MapFollowModule is IFollowModule, FollowValidatorFollowModuleBase {
    mapping(uint256 => MapMapFollowConfig) public mapFollowByProfile;

    constructor(address hub) ModuleBase(hub) {}

    function initializeFollowModule(uint256 profileId, bytes calldata data)
        external
        override
        onlyHub
        returns (bytes memory)
    {
        (address mapAddress, address followingAddress) = abi.decode(
            data,
            (address, address)
        );

        mapFollowByProfile[profileId] = MapMapFollowConfig(
            mapAddress,
            followingAddress
        );

        return data;
    }

    function processFollow(
        address follower,
        uint256 profileId,
        bytes calldata // data
    ) external view override {
        _checkProximity(follower, profileId);
    }

    function followModuleTransferHook(
        uint256 profileId,
        address from,
        address to,
        uint256 followNFTTokenId
    ) external view override {
        if (from != address(0)) {
            revert Errors.nonTransferable();
        }
    }

    function _checkProximity(address _user, uint256 _profileId) private view {
        if (mapFollowByProfile[_profileId].mapAddress != address(0)) {
            if (
                Map(mapFollowByProfile[_profileId].mapAddress).getUserLocation(
                    _user
                ) !=
                Map(mapFollowByProfile[_profileId].mapAddress).getUserLocation(
                    mapFollowByProfile[_profileId].followingAddress
                )
            ) {
                revert Errors.notInLocation();
            }
        }
    }
}
