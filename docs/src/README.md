# Lens Map 🌱 🗺️

A map app based on Lens Protocol. Follow & Collect modules are gated by location, represented by a ERC1155 token.

## Map (ERC1155)
- The entire (-90 to 90) latitudes and (0 to 180E & 180W) longitudes are split into a configurable & predictible amount of locations
- A base `_move` function can be used to burn old location token & mint the new location token

Packed Location             |  Account Motion
:-------------------------:|:-------------------------:
![](https://i.imgur.com/axSt3eK.png)  |  ![](https://i.imgur.com/AzdXqKS.png)


<br/>

## MapFollowModule

- Initializing the module sets the map the profile is on
- Processing the follow verifies the target profile account holds the same location token as caller profile

## MapCollectoModule

- Initializing the module sets the map the profile is on
- Processing the collect verifies the publication was created in the same location as caller profile
  

<br/>

## [DOCS](docs/src/SUMMARY.md)
