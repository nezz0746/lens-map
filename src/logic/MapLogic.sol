// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import {Coordinate} from "../libs/Structs.sol";
import {Errors} from "../libs/Errors.sol";

/**
 * @title MapLogic
 * @author nezzar.eth
 * @notice This contract holds the logic to encode/decode coordinates & locationIDs.
 */
contract MapLogic {
    string public name;
    mapping(address => uint256) internal userCoordinates;
    uint16 internal _latStep;
    uint16 internal _lngStep;
    uint16 internal _maxLat;
    uint16 internal _maxLng;
    uint8 internal maxSizeOfCoordinate = 16;
    uint16 public multiplicator = uint16(100);

    ////////////////////// PUBLIC FUNCTIONS /////////////////////

    /**
     * @dev Returns map configuration
     */
    function getConfiguration()
        public
        view
        returns (
            uint16,
            uint16,
            uint16
        )
    {
        return (_latStep, _lngStep, multiplicator);
    }

    /**
     * @dev Returns user's locationID
     */
    function getUserLocation(address account) public view returns (uint256) {
        return userCoordinates[account];
    }

    /**
     * @dev Decodes locationID to area coordinates
     */
    function decodeLocationId(uint256 locationId)
        external
        view
        returns (Coordinate[4] memory)
    {
        return _decodeLocation(locationId);
    }

    ////////////////////// INTERNAL FUNCTIONS /////////////////////

    /**
     * @dev Converts user's coordinates to compatible coordinates length
     */
    function _toCoordinates(uint256 lat, uint256 lng)
        internal
        view
        returns (Coordinate memory)
    {
        if (lat > _maxLat) revert Errors.invalidCoordinates();
        if (lng > _maxLng) revert Errors.invalidCoordinates();

        return
            Coordinate(
                uint16(lat / multiplicator),
                uint16(lng / multiplicator)
            );
    }

    /**
     * @dev Encode area coordinates to packed uint256 (locationID)
     */
    function _encodeLocationId(Coordinate[4] memory squareCoordinates)
        internal
        view
        returns (uint256)
    {
        uint256 id;

        for (uint256 i = 0; i < 4; i++) {
            id +=
                uint256(squareCoordinates[i].lat) *
                uint256(2)**(256 - (maxSizeOfCoordinate * (2 * i + 1)));
            id +=
                uint256(squareCoordinates[i].lng) *
                uint256(2)**(256 - (maxSizeOfCoordinate * (2 * i + 2)));
        }
        return id;
    }

    /**
     * @dev Decode locationID to area coordinates
     */
    function _decodeLocation(uint256 locationId)
        internal
        view
        returns (Coordinate[4] memory)
    {
        Coordinate[4] memory coordinates;
        for (uint256 i = 0; i < 4; i++) {
            coordinates[i].lat = uint16(
                locationId / (2**(256 - (maxSizeOfCoordinate * (2 * i + 1))))
            );
            locationId -=
                uint256(coordinates[i].lat) *
                uint256(2)**(256 - (maxSizeOfCoordinate * (2 * i + 1)));
            coordinates[i].lng = uint16(
                locationId / (2**(256 - (maxSizeOfCoordinate * (2 * i + 2))))
            );
            locationId -=
                uint256(coordinates[i].lng) *
                uint256(2)**(256 - (maxSizeOfCoordinate * (2 * i + 2)));
        }

        return coordinates;
    }

    /**
     * @dev Predict locationID of area from point coordinates
     */
    function _detectLocation(Coordinate memory coordinates)
        internal
        view
        returns (uint256)
    {
        Coordinate memory bottomLeft = Coordinate(
            coordinates.lat - (coordinates.lat % _latStep),
            coordinates.lng - (coordinates.lng % _lngStep)
        );

        return
            _encodeLocationId(
                Coordinate[4](
                    [
                        bottomLeft,
                        Coordinate(bottomLeft.lat + _latStep, bottomLeft.lng),
                        Coordinate(
                            bottomLeft.lat + _latStep,
                            bottomLeft.lng + _lngStep
                        ),
                        Coordinate(bottomLeft.lat, bottomLeft.lng + _lngStep)
                    ]
                )
            );
    }
}
