# MapFollowModule
[Git Source](https://github.com/nezz0746/lens-simple-map/blob/95972a29578cd8a5ca3ebd68f73f966d33940d9b/src/MapFollowModule.sol)

**Inherits:**
IFollowModule, FollowValidatorFollowModuleBase

**Author:**
nezzar.eth

*Allows certain Lens profiles to follow other profiles based on
their location on the map.*


## State Variables
### mapFollowByProfile

```solidity
mapping(uint256 => MapFollowConfig) public mapFollowByProfile;
```


## Functions
### constructor


```solidity
constructor(address hub) ModuleBase(hub);
```

### initializeFollowModule


```solidity
function initializeFollowModule(uint256 profileId, bytes calldata data)
    external
    override
    onlyHub
    returns (bytes memory);
```

### processFollow


```solidity
function processFollow(address follower, uint256 profileId, bytes calldata) external view override;
```

### followModuleTransferHook


```solidity
function followModuleTransferHook(uint256 profileId, address from, address to, uint256 followNFTTokenId)
    external
    view
    override;
```

### _checkProximity


```solidity
function _checkProximity(address _user, uint256 _profileId) private view;
```

