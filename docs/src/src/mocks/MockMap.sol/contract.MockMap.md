# MockMap
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/a30c376db312f36a38577517f8db496f70da23ed/src/mocks/MockMap.sol)

**Inherits:**
[Map](/src/Map.sol/contract.Map.md)


## Functions
### constructor


```solidity
constructor(string memory _name, string memory _baseURI, uint16 _numberOfTiles) Map(_name, _baseURI, _numberOfTiles);
```

### detectLocation


```solidity
function detectLocation(uint256 lat, uint256 lng) public view returns (uint256);
```

### move


```solidity
function move(address account, uint256 lat, uint256 lng) public;
```

