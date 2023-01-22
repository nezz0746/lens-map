// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ModuleBase} from "@lens/core/modules/ModuleBase.sol";
import {FollowValidationModuleBase} from "@lens/core/modules/FollowValidationModuleBase.sol";
import {ICollectModule} from "@lens/interfaces/ICollectModule.sol";
import {Map} from "./Map.sol";
import "./libs/Errors.sol";
import "./libs/Structs.sol";

/**
 * @title MapCollectModule
 * @author nezzar.eth
 * @dev Allows certain Lens profiles to collect a post based on
 * their location & the location the post was created in, on the Map.
 */
contract MapCollectModule is FollowValidationModuleBase, ICollectModule {
    mapping(uint256 => mapping(uint256 => MapCollectConfig))
        public proximityByPublicationByProfile;

    constructor(address hub) ModuleBase(hub) {}

    function initializePublicationCollectModule(
        uint256 profileId,
        uint256 pubId,
        bytes calldata data
    ) external override onlyHub returns (bytes memory) {
        (address mapAddress, uint256 locationId) = abi.decode(
            data,
            (address, uint256)
        );

        proximityByPublicationByProfile[profileId][pubId] = MapCollectConfig(
            mapAddress,
            locationId
        );

        return data;
    }

    /**
     * @dev Processes a collect by:
     *  1. Ensuring the collector is in the same location as the publication's
     */
    function processCollect(
        uint256 referrerProfileId,
        address collector,
        uint256 profileId,
        uint256 pubId,
        bytes calldata data
    ) external view override {
        _checkProximity(collector, profileId, pubId);
    }

    function _checkProximity(
        address _collector,
        uint256 _profileId,
        uint256 _pubId
    ) private view {
        if (
            proximityByPublicationByProfile[_profileId][_pubId].mapAddress !=
            address(0)
        ) {
            Map map = Map(
                proximityByPublicationByProfile[_profileId][_pubId].mapAddress
            );

            uint256 userLocation = map.getUserLocation(_collector);
            uint256 publicationLocation = proximityByPublicationByProfile[
                _profileId
            ][_pubId].locationId;

            if (userLocation != publicationLocation) {
                revert Errors.notInLocation();
            }
        }
    }
}
