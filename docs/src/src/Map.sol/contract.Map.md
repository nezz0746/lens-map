# Map
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/a30c376db312f36a38577517f8db496f70da23ed/src/Map.sol)

**Inherits:**
[MapLogic](/src/logic/MapLogic.sol/contract.MapLogic.md), ERC1155

**Author:**
nezzar.eth

This contract is used to manage holder's positions represented by encoded ERC1155 tokens.


## Functions
### constructor


```solidity
constructor(string memory _name, string memory _baseURI, uint16 _numberOfTiles) ERC1155(_baseURI);
```

### onlyValidAccount


```solidity
modifier onlyValidAccount(address account);
```

### _move

Replace account's location token with new one.


```solidity
function _move(address account, uint256 lat, uint256 lng) internal onlyValidAccount(account);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|Address of the account to move.|
|`lat`|`uint256`|Latitude of the new location|
|`lng`|`uint256`|Longitude of the new location|


### _beforeTokenTransfer


```solidity
function _beforeTokenTransfer(address, address from, address to, uint256[] memory, uint256[] memory, bytes memory)
    internal
    virtual
    override;
```

### supportsInterface


```solidity
function supportsInterface(bytes4 interfaceId) public view override(ERC1155) returns (bool);
```

## Events
### Move

```solidity
event Move(
    address indexed account, uint256 lat, uint256 lng, uint256 indexed previousLocationID, uint256 indexed newLocationID
);
```

