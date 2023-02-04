# MapLogic
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/a30c376db312f36a38577517f8db496f70da23ed/src/logic/MapLogic.sol)

**Author:**
nezzar.eth

This contract holds the logic to encode/decode coordinates & locationIDs.


## State Variables
### name

```solidity
string public name;
```


### userCoordinates

```solidity
mapping(address => uint256) internal userCoordinates;
```


### _latStep

```solidity
uint16 internal _latStep;
```


### _lngStep

```solidity
uint16 internal _lngStep;
```


### _maxLat

```solidity
uint16 internal _maxLat;
```


### _maxLng

```solidity
uint16 internal _maxLng;
```


### maxSizeOfCoordinate

```solidity
uint8 internal maxSizeOfCoordinate = 16;
```


### multiplicator

```solidity
uint16 public multiplicator = uint16(100);
```


## Functions
### getConfiguration

*Returns map configuration*


```solidity
function getConfiguration() public view returns (uint16, uint16, uint16);
```

### getUserLocation

*Returns user's locationID*


```solidity
function getUserLocation(address account) public view returns (uint256);
```

### decodeLocationId

*Decodes locationID to area coordinates*


```solidity
function decodeLocationId(uint256 locationId) external view returns (Coordinate[4] memory);
```

### _toCoordinates

*Converts user's coordinates to compatible coordinates length*


```solidity
function _toCoordinates(uint256 lat, uint256 lng) internal view returns (Coordinate memory);
```

### _encodeLocationId

*Encode area coordinates to packed uint256 (locationID)*


```solidity
function _encodeLocationId(Coordinate[4] memory squareCoordinates) internal view returns (uint256);
```

### _decodeLocation

*Decode locationID to area coordinates*


```solidity
function _decodeLocation(uint256 locationId) internal view returns (Coordinate[4] memory);
```

### _detectLocation

*Predict locationID of area from point coordinates*


```solidity
function _detectLocation(Coordinate memory coordinates) internal view returns (uint256);
```

