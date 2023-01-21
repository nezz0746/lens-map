// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./logic/MapLogic.sol";
import "./libs/Structs.sol";
import "./libs/Errors.sol";

/**
 * @title Map contract
 * @author nezzar.eth
 * @notice This contract is used to manage holder's positions represented by encoded ERC1155 tokens.
 */
contract Map is MapLogic, ERC1155 {
    event Move(
        address indexed account,
        uint256 lat,
        uint256 lng,
        uint256 indexed previousLocationID,
        uint256 indexed newLocationID
    );

    constructor(
        string memory _name,
        string memory _baseURI,
        uint16 _numberOfTiles
    ) ERC1155(_baseURI) {
        if (_numberOfTiles <= 0) revert Errors.invalidNumberOfTiles();

        uint16 step = (uint16(180) * multiplicator) / _numberOfTiles;

        name = _name;
        _latStep = step;
        _lngStep = 2 * step;

        _maxLat = uint16(180) * multiplicator;
        _maxLng = uint16(360) * multiplicator;
    }

    ///////////////////// MODIFIERS ///////////////////////////

    modifier onlyValidAccount(address account) {
        if (tx.origin != msg.sender || account != msg.sender)
            revert Errors.accountNotSender();
        _;
    }

    ///////////////////// INTERNAL FUNCTIONS //////////////////

    /// @notice Replace account's location token with new one.
    /// @param account Address of the account to move.
    /// @param lat Latitude of the new location (with any precision, destined to be indexed in the event @note refactor?)
    /// @param lng Longitude of the new location (with any precision, destined to be indexed in the event @note refactor?)
    function _move(
        address account,
        uint256 lat,
        uint256 lng
    ) internal onlyValidAccount(account) {
        uint256 locationId = _detectLocation(_toCoordinates(lat, lng));
        uint256 previousLocationId = userCoordinates[account];

        if (locationId == previousLocationId)
            revert Errors.movingToSameLocation();

        _mint(account, locationId, 1, "");

        if (previousLocationId != 0) {
            _burn(account, previousLocationId, 1);
        }

        userCoordinates[account] = locationId;

        emit Move(account, lat, lng, previousLocationId, locationId);
    }

    function _beforeTokenTransfer(
        address,
        address from,
        address to,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) internal virtual override {
        if (from != address(0) && to != address(0))
            revert Errors.nonTransferable();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
