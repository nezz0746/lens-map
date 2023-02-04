# MapCollectModule
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/a30c376db312f36a38577517f8db496f70da23ed/src/MapCollectModule.sol)

**Inherits:**
FollowValidationModuleBase, ICollectModule

**Author:**
nezzar.eth

*Allows certain Lens profiles to collect a post based on
their location & the location the post was created in, on the Map.*


## State Variables
### proximityByPublicationByProfile

```solidity
mapping(uint256 => mapping(uint256 => MapCollectConfig)) public proximityByPublicationByProfile;
```


## Functions
### constructor


```solidity
constructor(address hub) ModuleBase(hub);
```

### initializePublicationCollectModule


```solidity
function initializePublicationCollectModule(uint256 profileId, uint256 pubId, bytes calldata data)
    external
    override
    onlyHub
    returns (bytes memory);
```

### processCollect

*Processes a collect by:
1. Ensuring the collector is in the same location as the publication's*


```solidity
function processCollect(
    uint256 referrerProfileId,
    address collector,
    uint256 profileId,
    uint256 pubId,
    bytes calldata data
) external view override;
```

### _checkProximity


```solidity
function _checkProximity(address _collector, uint256 _profileId, uint256 _pubId) private view;
```

