# MapCollectModule
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/95972a29578cd8a5ca3ebd68f73f966d33940d9b/src/MapCollectModule.sol)

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

